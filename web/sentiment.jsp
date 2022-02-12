<%@page import="edu.stanford.nlp.ling.CoreAnnotations"%>
<%@page import="edu.stanford.nlp.neural.rnn.RNNCoreAnnotations" %>
<%@page import="edu.stanford.nlp.pipeline.Annotation" %>
<%@page import="edu.stanford.nlp.pipeline.StanfordCoreNLP" %>
<%@page import="edu.stanford.nlp.sentiment.SentimentCoreAnnotations" %>
<%@page import="edu.stanford.nlp.trees.Tree" %>
<%@page import="edu.stanford.nlp.util.CoreMap" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.Properties"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Twitter Sentiment</title>
    </head>
    <body>
        <%!
            
              static StanfordCoreNLP pipeline;
             public void init() 
            {
                 //pipeline = new StanfordCoreNLP("My.properties");
            Properties props = new Properties();
        props.setProperty("annotators", "tokenize, ssplit, parse, sentiment");
     
               pipeline= new StanfordCoreNLP(props);
            }
            
            
            

            
         %>
         <%
                
                String tweet="null";
                int mainSentiment = 0;
                int longest = 0;
                //String sentiment1="null";
                String partText;
                String[] sentimentText = { "Very Negative","Negative", "Neutral", "Positive", "Very Positive"};
        
                String connectionURL = "jdbc:derby://localhost:1527/LINKS ";
                Connection connection = null;
                Statement statement = null;
                ResultSet rs = null;
                
                   Class.forName("org.apache.derby.jdbc.ClientDriver");
                    connection = DriverManager.getConnection(connectionURL,"root","root");
                    statement = connection.createStatement();
                    String SQL = "SELECT MESSAGE FROM ROOT.TWITTER";
        
                try
                {
                    String sql1=null;
                    rs=statement.executeQuery(SQL);
                    while (rs.next()) 
                    {
                        tweet=rs.getString("MESSAGE");
                        if (tweet != null && tweet.length() > 0) 
                        {
                            Annotation annotation = pipeline.process(tweet);
                            for (CoreMap sentence : annotation.get(CoreAnnotations.SentencesAnnotation.class)) 
                            {
                                Tree tree = sentence.get(SentimentCoreAnnotations.SentimentAnnotatedTree.class);
                                int sentiment = RNNCoreAnnotations.getPredictedClass(tree);
                                out.print(sentiment);
                                String sentiment1 = sentence.toString();
                                 sentiment1=sentimentText[sentiment];
                                
                                //out.println(sentiment1);
                                //out.println("<br>");
                                try
                                {
                                    sql1 = "INSERT INTO ROOT.SENTIMENT VALUES (?)";
                                    PreparedStatement statement1 = connection.prepareStatement(sql1);
                                    statement1.setString(1, sentiment1);
                                    statement1.executeUpdate();
                                }
                                catch(Exception e)
                                {
                                     System.out.println("Sql  exception"+e);
                                }
                            }
                        } 
                    }  
            
                }//try
                catch(Exception e)
                {}
                Thread.sleep(10000);
                response.sendRedirect("charts.jsp");
             %>
    </body>
</html>
