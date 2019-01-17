# IBM MQ

IBM provides a free version of IBM MQ ("MQ Advanced for Developers")
that can be used by a single developer on a single physical or virtual
machine (or container).

Pull the official Docker image from [ibmcom/mq on Docker Hub](
https://hub.docker.com/r/ibmcom/mq) and see the
[Default developer configuration](
https://github.com/ibm-messaging/mq-container/blob/master/docs/developer-config.md).

Also download the [MQ client](
https://developer.ibm.com/messaging/mq-downloads/) JAR installer
(requires registration) corresponding to the Docker image version to
acquire OSGi bundles for the MQ client and its prerequisites.

Follow a short IBM tutorial to
[Connect a simple MQ application to a queue manager](
https://developer.ibm.com/messaging/learn-mq/mq-tutorials/mq-connect-to-queue-manager/#docker)
using the official Docker image.

