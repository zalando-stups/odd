======================
Odd - SSH Bastion Host
======================

Docker image for a SSH jump host running OpenSSH server.
A bastion host acts as a proxy to access internal/private subnets from the public internet.

Environment Variables
=====================

The Docker image expects the following environment variables to be set:

``ALLOWED_REMOTE_NETWORKS``
    List of IP networks (CIDR) the bastion host is allowed to access.
``GRANTING_SERVICE_SSH_KEY``
    The public SSH key for the "granting-service" user.
``GRANTING_SERVICE_URL``
    URL of the SSH Access Granting Service (even_).

Testing
=======

.. code-block:: bash

    $ ./build.sh
    $ export GRANTING_SERVICE_SSH_KEY=$(cat ~/.ssh/ssh-access-granting-service.pub)
    $ docker run -d -p 2222:22 -e GRANTING_SERVICE_SSH_KEY="$GRANTING_SERVICE_SSH_KEY" -e GRANTING_SERVICE_URL=https://even.example.org -e ALLOWED_NETWORKS=10.0.0.0/8 stups/odd
    $ ssh -p 2222 granting-service@localhost grant-ssh-access jdoe
    
.. _even: https://github.com/zalando-stups/even
