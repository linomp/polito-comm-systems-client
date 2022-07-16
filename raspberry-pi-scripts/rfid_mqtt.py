#!/usr/bin/env python

import RPi.GPIO as GPIO
import time

from mfrc522 import SimpleMFRC522

import paho.mqtt.client as mqtt

broker_url = "apps.xmp.systems"
broker_port = 1883
topic = "rfid-test"

try:
    client = mqtt.Client()
    client.connect(broker_url, broker_port)
    # Important for correct processing of outgoing entwork data
    # source: https://pypi.org/project/paho-mqtt/#network-loop
    client.loop_start()

    reader = SimpleMFRC522()

    while True:
        nfc_tag_value, text  = reader.read()
        print('Read RFID: ', nfc_tag_value)
        # qos 2 to send exactly once
        message_info = client.publish(topic=topic, qos=2, payload=str(nfc_tag_value))
        # will block until the message is published.
        # source: https://pypi.org/project/paho-mqtt/#publishing
        message_info.wait_for_publish()
        time.sleep(1)

except Exception as e:
    print(e)
finally:
    GPIO.cleanup()
