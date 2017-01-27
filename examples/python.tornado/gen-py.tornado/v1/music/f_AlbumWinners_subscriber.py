#
# Autogenerated by Frugal Compiler (2.0.0-RC9)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#



import sys
import traceback

from thrift.Thrift import TApplicationException
from thrift.Thrift import TMessageType
from thrift.Thrift import TType
from tornado import gen
from frugal.exceptions import FrugalTApplicationExceptionType
from frugal.middleware import Method
from frugal.subscription import FSubscription
from frugal.transport import TMemoryOutputBuffer

from .ttypes import *




class AlbumWinnersSubscriber(object):
    """
    Scopes are a Frugal extension to the IDL for declaring PubSub
    semantics. Subscribers to this scope will be notified if they win a contest.
    Scopes must have a prefix.
    """

    _DELIMITER = '.'

    def __init__(self, provider, middleware=None):
        """
        Create a new AlbumWinnersSubscriber.

        Args:
            provider: FScopeProvider
            middleware: ServiceMiddleware or list of ServiceMiddleware
        """

        middleware = middleware or []
        if middleware and not isinstance(middleware, list):
            middleware = [middleware]
        middleware += provider.get_middleware()
        self._middleware = middleware
        self._provider = provider

    @gen.coroutine
    def subscribe_Winner(self, Winner_handler):
        """
            Winner_handler: function which takes FContext and Album
        """

        op = 'Winner'
        prefix = 'v1.music.'
        topic = '{}AlbumWinners{}{}'.format(prefix, self._DELIMITER, op)

        transport, protocol_factory = self._provider.new_subscriber()
        yield transport.subscribe(topic, self._recv_Winner(protocol_factory, op, Winner_handler))

    def _recv_Winner(self, protocol_factory, op, handler):
        method = Method(handler, self._middleware)

        def callback(transport):
            iprot = protocol_factory.get_protocol(transport)
            ctx = iprot.read_request_headers()
            mname, _, _ = iprot.readMessageBegin()
            if mname != op:
                iprot.skip(TType.STRUCT)
                iprot.readMessageEnd()
                raise TApplicationException(FrugalTApplicationExceptionType.UNKNOWN_METHOD)
            req = Album()
            req.read(iprot)
            iprot.readMessageEnd()
            try:
                method([ctx, req])
            except:
                traceback.print_exc()
                sys.exit(1)

        return callback




