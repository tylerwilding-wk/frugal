package com.workiva.frugal.processor;

import com.workiva.frugal.protocol.FContext;
import com.workiva.frugal.protocol.FProtocol;
import org.apache.thrift.TApplicationException;
import org.apache.thrift.TException;
import org.apache.thrift.protocol.TMessage;
import org.apache.thrift.protocol.TMessageType;
import org.apache.thrift.protocol.TProtocolUtil;
import org.apache.thrift.protocol.TType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

/**
 * Abstract base FProcessor implementation. This should only be used by generated code.
 */
public abstract class FBaseProcessor implements FProcessor {

    private static final Logger LOGGER = LoggerFactory.getLogger(FBaseProcessor.class);
    protected static final Object WRITE_LOCK = new Object();

    private Map<String, FProcessorFunction> processMap;

    @Override
    public void process(FProtocol iprot, FProtocol oprot) throws TException {
        if (processMap == null) {
            processMap = getProcessMap();
        }
        FContext ctx = iprot.readRequestHeader();
        TMessage message = iprot.readMessageBegin();
        FProcessorFunction processor = processMap.get(message.name);
        if (processor != null) {
            try {
                processor.process(ctx, iprot, oprot);
            } catch (Exception e) {
                LOGGER.error("User handler code threw unhandled exception on request with correlation id "
                        + ctx.getCorrelationId(), e);
                throw e;
            }
            return;
        }
        TProtocolUtil.skip(iprot, TType.STRUCT);
        iprot.readMessageEnd();
        TApplicationException e =
                new TApplicationException(TApplicationException.UNKNOWN_METHOD, "Unknown function " + message.name);
        synchronized (WRITE_LOCK) {
            oprot.writeResponseHeader(ctx);
            oprot.writeMessageBegin(new TMessage(message.name, TMessageType.EXCEPTION, 0));
            e.write(oprot);
            oprot.writeMessageEnd();
            oprot.getTransport().flush();
        }
        throw e;
    }

    /**
     * Returns the map of method names to FProcessorFunctions.
     *
     * @return FProcessorFunction map
     */
    protected abstract Map<String, FProcessorFunction> getProcessMap();
}
