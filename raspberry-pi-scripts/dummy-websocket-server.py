#!/usr/bin/env python

from simple_websocket_server import WebSocketServer, WebSocket
import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
import time

#GPIO.cleanup()

global reader 
reader= SimpleMFRC522()

class NfcTagReaderSocket(WebSocket):

    # def read_nfc_tag(self):
    #     global reader
    #     try:
    #         id, text = reader.read()
    #         print('ID :', id)
    # #		print('TEXT : ',text)
    #         return id

    #     finally:
    # #		GPIO.cleanup()
    #         print('all good')

    def connected(self):
        global reader
        print("reader is currently: ", reader)

        print(self.address, 'connected')
        for client in clients:
            client.send_message(self.address[0] + u' - connected')
        clients.append(self)

    def handle_close(self):
        clients.remove(self)
        print(self.address, 'closed')
        for client in clients:
            client.send_message(self.address[0] + u' - disconnected')

    def handle(self):
        if self.data == "read_nfc_tag":
            print('reading:')
            nfc_tag_value, text  = reader.read()
            print('Id : ', nfc_tag_value)
            #nfc_tag_value = ""
            for client in clients:
                client.send_message(str(nfc_tag_value))
            time.sleep(2)

clients = []

try:
    server = WebSocketServer('', 9999, NfcTagReaderSocket)
    server.serve_forever()
finally:
    GPIO.cleanup()
