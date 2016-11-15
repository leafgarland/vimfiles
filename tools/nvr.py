#!c:\dev\tools\python35\python.exe

"""
Copyright (c) 2015 - present Marco Hinz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"""

import sys
import os
import textwrap
import argparse
import subprocess
import glob
import time

from neovim import attach


class Neovim():
    def __init__(self, address):
        self.address    = address
        self.server     = None
        self._msg_shown = False

    def attach(self):
        try:
            if ':' in self.address:
                ip, port = self.address.split(':')
                self.server = attach('tcp', address=ip, port=int(port))
            elif self.address == '':
                pipes = glob.glob(r"\\.\pipe\nvim-*")
                if len(pipes) > 0:
                    self.address = pipes[0]
                self.server = attach('socket', path=self.address)
        except:
            pass

    def is_attached(self, silent=False):
        if self.server:
            return True
        else:
            if not silent and not self._msg_shown:
                self._show_msg()
                self._msg_shown = True
            return False

    def execute(self, arguments, cmd='edit', silent=False, wait=False):
        if self.is_attached(silent):
            self._execute_remotely(arguments, cmd, wait)
        else:
            self._execute_locally([], True, False)
            time.sleep(2)
            self.attach()
            self._execute_remotely(arguments, cmd, wait)

    def _execute_locally(self, arguments, silent, wait):
        if not arguments and not silent:
            print('No arguments were given!')
        else:
            vimInstall = r"C:\Dev\Tools\vim\Neovim-master"
            env = os.environ.copy()
            env['VIM'] = vimInstall + r"\share\nvim"
            env['VIMRUNTIME'] = vimInstall + r"\share\nvim\runtime"
            proc = subprocess.Popen([r'C:\dev\tools\vim\Neovim-Qt\bin\nvim-qt.exe', '--nvim', vimInstall + r'\bin\nvim.exe', '-qwindowgeometry', '800x800+10+10', '--'] + arguments, env=env)
            if wait:
                proc.wait()
    def _execute_remotely(self, arguments, cmd, wait):
        c = None
        for fname in reversed(arguments):
            if fname.startswith('+'):
                c = fname[1:]
                continue
            self.server.command('{} {}'.format(cmd, prepare_filename(fname)))
            if wait:
                self.server.command('augroup nvr')
                self.server.command('autocmd BufDelete <buffer> silent! call rpcnotify({}, "BufDelete")'.format(self.server.channel_id))
                self.server.command('augroup END')
        if c:
            self.server.command(c)
        if wait:
            bufcount = len(arguments) - (1 if c else 0)
            def notification_cb(msg, _args):
                nonlocal bufcount
                if msg == 'BufDelete':
                    bufcount -= 1
                    if bufcount == 0:
                        self.server.stop_loop()
            def err_cb(error):
                print(error, file=sys.stderr)
                self.server.stop_loop()
                sys.exit(1)
            self.server.run_loop(None, notification_cb, None, err_cb)

    def _show_msg(self):
        a = self.address
        print(textwrap.dedent("""
            [!] Can't connect to: {}

                This script and the nvim process have to use the same address.
                Use `:echo v:servername` in nvim to verify that.

                SOLUTION 1 (from server side):

                    Expose $NVIM_LISTEN_ADDRESS to the environment before
                    starting nvim, so that v:servername gets set accordingly.

                    $ NVIM_LISTEN_ADDRESS={} nvim

                SOLUTION 2 (from client side):

                    Expose $NVIM_LISTEN_ADDRESS to the environment before
                    using nvr or use its --servername option. If neither
                    is given, nvr assumes \"/tmp/nvimsocket\".

                    $ NVIM_LISTEN_ADDRESS={} nvr --remote file1 file2
                    $ nvr --servername {} --remote file1 file2

                Use any of the -silent options to suppress this message.

            [*] Starting new nvim process with address: {}
            """.format(a, a, a, a, a)))


def parse_args():
    form_class = argparse.RawDescriptionHelpFormatter
    usage      = '{} [arguments]'.format(sys.argv[0])
    epilog     = 'Happy hacking!'
    desc       = textwrap.dedent("""
        Script that allows remote control of nvim processes.
        If no process is found, a new one will be started.

            $ nvr --remote +3 file1 file2
            $ nvr --remote-send 'iabc<cr><esc>'
            $ nvr --remote-expr v:progpath
            $ nvr --remote-expr 'map([1,2,3], \"v:val + 1\")'
            $ nvr --servername /tmp/foo --remote file
            $ nvr --servername 127.0.0.1:6789 --remote file

        Any arguments not consumed by flags, will be fed to
        --remote, so this is equivalent:

            $ nvr file1 file2
            $ nvr --remote file1 file2

    """)

    parser = argparse.ArgumentParser(
            formatter_class = form_class,
            usage           = usage,
            epilog          = epilog,
            description     = desc)

    parser.add_argument('--remote',
            nargs   = '+',
            metavar = '<file>',
            help    = 'Edit files in a remote instance. If no server is found, throw an error and run nvim locally instead.')
    parser.add_argument('--remote-wait',
            nargs   = '+',
            metavar = '<file>',
            help    = 'Same as --remote, but block until remote instance exits.')
    parser.add_argument('--remote-silent',
            nargs   = '+',
            metavar = '<file>',
            help    = "Same as --remote, but don't throw an error if no server is found.")
    parser.add_argument('--remote-wait-silent',
            action  = 'store_true',
            help    = "Same as --remote-silent, but block until remote instance exits.")

    parser.add_argument('--remote-tab', '-p',
            nargs   = '+',
            metavar = '<file>',
            help    = 'Tabedit files in a remote instance. If no server is found, throw an error and run nvim locally instead.')
    parser.add_argument('--remote-tab-wait',
            nargs   = '+',
            metavar = '<file>',
            help    = 'Same as --remote-tab, but block until remote instance exits.')
    parser.add_argument('--remote-tab-silent',
            nargs   = '+',
            metavar = '<file>',
            help    = "Same as --remote-tab, but don't throw an error if no server is found.")
    parser.add_argument('--remote-tab-wait-silent',
            nargs   = '+',
            metavar = '<file>',
            help    = "Same as --remote-tab-silent, but block until remote instance exits.")

    parser.add_argument('--remote-send',
            metavar = '<keys>',
            help    = 'Send key presses.')
    parser.add_argument('--remote-expr',
            metavar = '<expr>',
            help    = 'Evaluate expression on server and print result in shell.')

    parser.add_argument('--servername',
            metavar = '<addr>',
            help    = 'Set the address to be used (overrides $NVIM_LISTEN_ADDRESS).')
    parser.add_argument('--serverlist',
            action  = 'store_true',
            help    = '''Print the address to be used (TCP or Unix domain socket). Opposed to Vim there is no central
            instance that knows about all running servers.''')

    parser.add_argument('-l',
            action  = 'store_true',
            help    = 'Change to previous window via ":wincmd p".')
    parser.add_argument('-f',
            action  = 'store_true',
            help    = 'Bring to foreground.')
    parser.add_argument('-c',
            action  = 'append',
            metavar = '<cmd>',
            help    = 'Execute a command.')
    parser.add_argument('-o',
            nargs   = '+',
            metavar = '<file>',
            help    = 'Open files via ":split".')
    parser.add_argument('-O',
            nargs   = '+',
            metavar = '<file>',
            help    = 'Open files via ":vsplit".')

    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(0)

    return parser.parse_known_args()


def prepare_filename(fname):
    return os.path.abspath(fname).replace(" ", "\ ")


def main():
    flags, arguments = parse_args()
    address = os.environ.get('NVIM_LISTEN_ADDRESS')

    if flags.servername:
        address = flags.servername
    elif not address:
        address = ''

    if flags.serverlist:
        print(address)

    neovim = Neovim(address)
    neovim.attach()

    if flags.l and neovim.is_attached():
        neovim.server.command('wincmd p')

    if flags.f and neovim.is_attached():
        neovim.server.command('call GuiForeground()')

    try:
        arguments.remove('--')
    except ValueError:
        pass

    # Arguments not consumed by flags, are fed to --remote.
    if arguments:
        neovim.execute(arguments, 'edit')
    elif flags.remote:
        neovim.execute(flags.remote, 'edit')
    elif flags.remote_wait:
        neovim.execute(flags.remote_wait, 'edit', wait=True)
    elif flags.remote_silent:
        neovim.execute(flags.remote_silent, 'edit', silent=True)
    elif flags.remote_wait_silent:
        neovim.execute(flags.remote_wait_silent, 'edit', silent=True, wait=True)
    elif flags.remote_tab:
        neovim.execute(flags.remote_tab, 'tabedit')
    elif flags.remote_tab_wait:
        neovim.execute(flags.remote_tab_wait, 'tabedit', wait=True)
    elif flags.remote_tab_silent:
        neovim.execute(flags.remote_tab_silent, 'tabedit', silent=True)
    elif flags.remote_tab_wait_silent:
        neovim.execute(flags.remote_tab_wait_silent, 'tabedit', silent=True, wait=True)

    if flags.remote_send and neovim.is_attached():
        neovim.server.input(flags.remote_send)

    if flags.remote_expr and neovim.is_attached():
        result = ''
        try:
            result = neovim.server.eval(flags.remote_expr)
        except:
            print('Evaluation failed: ' + flags.remote_expr)
        if type(result) is bytes:
            print(result.decode())
        elif type(result) is list:
            print(list(map(lambda x: x.decode() if type(x) is bytes else x, result)))
        elif type(result) is dict:
            print({ (k.decode() if type(k) is bytes else k): v for (k,v) in result.items() })
        else:
            print(result)

    if flags.o and neovim.is_attached():
        for fname in flags.o:
            neovim.server.command('split {}'.format(prepare_filename(fname)))
    if flags.O and neovim.is_attached():
        for fname in flags.O:
            neovim.server.command('vsplit {}'.format(prepare_filename(fname)))

    if flags.c and neovim.is_attached():
        for cmd in flags.c:
            neovim.server.command(cmd)


if __name__ == '__main__':
    main()

