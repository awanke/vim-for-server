#!/usr/bin/env python
# encoding: utf-8

import SimpleHTTPServer
import SocketServer
import logging
import cgi
import subprocess


class AutoReleaseRequestHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    def do_GET(self):
        logging.warning("======= GET STARTED =======")
        logging.warning(self.headers)
        self.path = '/index.html'
        SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)

    def do_POST(self):
        logging.warning("======= POST STARTED =======")
        logging.warning(self.headers)
        form = cgi.FieldStorage(
            fp=self.rfile,
            headers=self.headers,
            environ={'REQUEST_METHOD': 'POST',
                     'CONTENT_TYPE': self.headers['Content-Type'],
            })
        logging.warning("======= POST VALUES =======")
        self.wfile.write('{"status":"OK"')
        for item in form.list:
            logging.warning(item)
            self.wfile.write(',"%s":"%s"\n' % (item.name, item.value))
        command = 'cd /home/www/%s/; git stash;git pull --rebase  origin %s ' % (
            form['environ'].value, form['branch'].value)
        self.wfile.write(',"command":"%s"' % command)
        self.wfile.write('}')
        subprocess.Popen(command, stdout=subprocess.PIPE,
                         stderr=subprocess.STDOUT, shell=True)


logging.warning("\n")

if __name__ == '__main__':
    print 'Starting server, use <Ctrl-C> to stop'
    server = SocketServer.TCPServer(('0.0.0.0', 1024), AutoReleaseRequestHandler)
    server.serve_forever()
