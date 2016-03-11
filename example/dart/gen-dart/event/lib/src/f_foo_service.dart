// Autogenerated by Frugal Compiler (1.0.5)
// DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING

library event.src.f_foo_scope;

import 'dart:async';

import 'dart:typed_data' show Uint8List;
import 'package:thrift/thrift.dart' as thrift;
import 'package:frugal/frugal.dart' as frugal;

import 'package:base/base.dart' as t_base;
import 'package:event/event.dart' as t_event;
import 'foo.dart' as t_foo_file;


/// This is a thrift service. Frugal will generate bindings that include 
/// a frugal Context for each service call.
abstract class FFoo extends t_base.FBaseFoo {

  /// Ping the server.
  Future ping(frugal.FContext ctx);

  /// Blah the server.
  Future<int> blah(frugal.FContext ctx, int num, String str, t_event.Event event);

  /// oneway methods don't receive a response from the server.
  Future oneWay(frugal.FContext ctx, int id, Map<int,String> req);
}

/// This is a thrift service. Frugal will generate bindings that include 
/// a frugal Context for each service call.
class FFooClient extends t_base.FBaseFooClient implements FFoo {

  FFooClient(frugal.FTransport transport, frugal.FProtocolFactory protocolFactory)
      : super(transport, protocolFactory) {
    _transport = transport;
    _transport.setRegistry(new frugal.FClientRegistry());
    _protocolFactory = protocolFactory;
    _oprot = _protocolFactory.getProtocol(_transport);
  }

  frugal.FTransport _transport;
  frugal.FProtocolFactory _protocolFactory;
  frugal.FProtocol _oprot;
  frugal.FProtocol get oprot => _oprot;

  /// Ping the server.
  Future ping(frugal.FContext ctx) async {
    var controller = new StreamController();
    _transport.register(ctx, _recvPingHandler(ctx, controller));
    try {
      oprot.writeRequestHeader(ctx);
      oprot.writeMessageBegin(new thrift.TMessage("ping", thrift.TMessageType.CALL, 0));
      t_foo_file.ping_args args = new t_foo_file.ping_args();
      args.write(oprot);
      oprot.writeMessageEnd();
      await oprot.transport.flush();
      return await controller.stream.first.timeout(ctx.timeout);
    } finally {
      _transport.unregister(ctx);
    }
  }

  _recvPingHandler(frugal.FContext ctx, StreamController controller) {
    pingCallback(thrift.TTransport transport) {
      try {
        var iprot = _protocolFactory.getProtocol(transport);
        iprot.readResponseHeader(ctx);
        thrift.TMessage msg = iprot.readMessageBegin();
        if (msg.type == thrift.TMessageType.EXCEPTION) {
          thrift.TApplicationError error = thrift.TApplicationError.read(iprot);
          iprot.readMessageEnd();
          if (error.type == frugal.FTransport.RESPONSE_TOO_LARGE) {
            controller.addError(new frugal.FMessageSizeError.response());
            return;
          }
          throw error;
        }

        t_foo_file.ping_result result = new t_foo_file.ping_result();
        result.read(iprot);
        iprot.readMessageEnd();
        controller.add(null);
      } catch(e) {
        controller.addError(e);
        rethrow;
      }
    }
    return pingCallback;
  }

  /// Blah the server.
  Future<int> blah(frugal.FContext ctx, int num, String str, t_event.Event event) async {
    var controller = new StreamController();
    _transport.register(ctx, _recvBlahHandler(ctx, controller));
    try {
      oprot.writeRequestHeader(ctx);
      oprot.writeMessageBegin(new thrift.TMessage("blah", thrift.TMessageType.CALL, 0));
      t_foo_file.blah_args args = new t_foo_file.blah_args();
      args.num = num;
      args.str = str;
      args.event = event;
      args.write(oprot);
      oprot.writeMessageEnd();
      await oprot.transport.flush();
      return await controller.stream.first.timeout(ctx.timeout);
    } finally {
      _transport.unregister(ctx);
    }
  }

  _recvBlahHandler(frugal.FContext ctx, StreamController controller) {
    blahCallback(thrift.TTransport transport) {
      try {
        var iprot = _protocolFactory.getProtocol(transport);
        iprot.readResponseHeader(ctx);
        thrift.TMessage msg = iprot.readMessageBegin();
        if (msg.type == thrift.TMessageType.EXCEPTION) {
          thrift.TApplicationError error = thrift.TApplicationError.read(iprot);
          iprot.readMessageEnd();
          if (error.type == frugal.FTransport.RESPONSE_TOO_LARGE) {
            controller.addError(new frugal.FMessageSizeError.response());
            return;
          }
          throw error;
        }

        t_foo_file.blah_result result = new t_foo_file.blah_result();
        result.read(iprot);
        iprot.readMessageEnd();
        if (result.isSetSuccess()) {
          controller.add(result.success);
          return;
        }

        if (result.awe != null) {
          controller.addError(result.awe);
          return;
        }
        if (result.api != null) {
          controller.addError(result.api);
          return;
        }
        throw new thrift.TApplicationError(
          thrift.TApplicationErrorType.MISSING_RESULT, "blah failed: unknown result"
        );
      } catch(e) {
        controller.addError(e);
        rethrow;
      }
    }
    return blahCallback;
  }

  /// oneway methods don't receive a response from the server.
  Future oneWay(frugal.FContext ctx, int id, Map<int,String> req) async {
    oprot.writeRequestHeader(ctx);
    oprot.writeMessageBegin(new thrift.TMessage("oneWay", thrift.TMessageType.ONEWAY, 0));
    t_foo_file.oneWay_args args = new t_foo_file.oneWay_args();
    args.id = id;
    args.req = req;
    args.write(oprot);
    oprot.writeMessageEnd();
    await oprot.transport.flush();
  }

}
