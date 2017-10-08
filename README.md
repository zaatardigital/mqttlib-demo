**MQTTLib** is a library written in [Xojo](http://xojo.com) for implementing the [MQTT Protocol](https://en.wikipedia.org/wiki/MQTT) in a nice way in your own projects. It comes as a module containing the classes, interfaces and other stuff.

 * For now, it handles the TCP connection only.
 * Although it hasn't been seriously tested yet, it should also work with the [SSLSocket](https://docs.xojo.com/index.php/SSLSocket) class if you provide a correctly setup instance to the TCPSocketAdapter class's constructor. The SSLSocket inherits from the [TCPSocket](https://docs.xojo.com/index.php/TCPSocket) and TCPSocketAdapter only use methods and events from TCPSockets.
 * Web sockets support might be implemented in the future.

MQTTLib is still in development and has only be tested in desktop projects and in a single thread (main thread) environment. While it may work in other types of project, it needs more extensive testing on these platforms. I'd be pleased to have your feedback and suggestions if you're testing it on any environment.

## What is MQTT ?

From [Wikipedia](https://en.wikipedia.org/wiki/MQTT):

> [MQTT](http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/mqtt-v3.1.1.html) (MQ Telemetry Transport or Message Queue Telemetry Transport) is an ISO standard [(ISO/IEC PRF 20922)](https://www.iso.org/standard/69466.html) publish-subscribe-based "lightweight" messaging protocol for use on top of the TCP/IP protocol. It is designed for connections with remote locations where a "small code footprint" is required or the network bandwidth is limited. The publish-subscribe messaging pattern requires a message broker. The broker is responsible for distributing messages to interested clients based on the topic of a message.

## Requirements

As of the date of this writing, MQTTLib is developed with Xojo 2017r2.1 IDE. For more informations, see Xojo's most updated system requirements here: http://developer.xojo.com/system-requirements.
 
## Licensing
MQTTLib is published under the very permissive [MIT license](https://choosealicense.com/licenses/mit/). Providing that you include the copyright and license notice in any copy of your source or compiled software, you can do whatever you want. We will be thankful to hear about how you are using MQTTLib or if you have made some interesting enhancements or fixes.

***
_Xojo is a registered trade mark of Xojo, Inc._