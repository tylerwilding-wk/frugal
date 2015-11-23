/**
 * Autogenerated by Frugal Compiler (0.0.1)
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */



import com.workiva.frugal.Provider;
import com.workiva.frugal.Transport;
import com.workiva.frugal.TransportFactory;
import com.workiva.frugal.Subscription;
import org.apache.thrift.TException;
import org.apache.thrift.protocol.*;
import org.apache.thrift.TApplicationException;

import org.apache.thrift.transport.TTransportException;

import org.apache.thrift.transport.TTransportFactory;

import javax.annotation.Generated;



/**
 * This docstring gets added to the generated code because it has
 * the @ sign.
 */
@Generated(value = "Autogenerated by Frugal Compiler (0.0.1)", date = "2015-11-23")
public class EventsPublisher {

	private static final String delimiter = ".";

	private Transport transport;
	private TProtocol protocol;
	private int seqId;

	public EventsPublisher(Provider provider) {
		Provider.Client client = provider.build();
		transport = client.getTransport();
		protocol = client.getProtocol();
	}

	/**
	 * This is a docstring.
	 */
	public void publishEventCreated(String user, Event req) throws TException {
		String op = "EventCreated";
		String prefix = String.format("foo.%s.", user);
		String topic = String.format("%sEvents%s%s", prefix, delimiter, op);
		transport.preparePublish(topic);
		seqId++;
		protocol.writeMessageBegin(new TMessage(op, TMessageType.CALL, seqId));
		req.write(protocol);
		protocol.writeMessageEnd();
		transport.flush();
	}
}
