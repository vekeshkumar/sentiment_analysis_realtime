<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.io.PrintWriter" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<%@page import="twitter4j.GeoLocation" %>
<%@page import="twitter4j.Query" %>
<%@page import="twitter4j.QueryResult" %>
<%@page import="twitter4j.Status" %>
<%@page import="twitter4j.Twitter" %>
<%@page import="twitter4j.TwitterException" %>
<%@page import="twitter4j.TwitterFactory" %>
<%@page import="twitter4j.conf.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@page import= "java.io.*" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Twitter Sentimental Analysis</title>
    </head>
    <body>
        <%
            //twitter app keys
            ConfigurationBuilder cb = new ConfigurationBuilder();
            cb.setDebugEnabled(true);
            cb.setOAuthConsumerKey("ctE6JfizKgCGscEhSexyGBL8z");
            cb.setOAuthConsumerSecret("v4oC3MvRlTWpYSlUCDV32bglj7jpRys4I0BdeUrbnKIDuy3GKN");
            cb.setOAuthAccessToken("3162603426-TQZ22iCulyB7y3YTSBA8kPsP6XiJUhIiwvB85oi");
            cb.setOAuthAccessTokenSecret("4jrj5EJgqCM1Njdh9ClhoBY2QL02gTrIcWhESbSopCpY2");
      
            Twitter twitter = new TwitterFactory(cb.build()).getInstance();
            String s="@";
            String Query1 = request.getParameter("query");
            s=s.concat(Query1);
            Query query = new Query(s);
            int numberOfTweets = 20;
            long lastID = Long.MAX_VALUE;
            ArrayList<Status> tweets = new ArrayList<>();
    
            while (tweets.size () < numberOfTweets) 
            {
                if (numberOfTweets - tweets.size() > 100)
                query.setCount(100);
                else 
                query.setCount(numberOfTweets - tweets.size());
                try 
                {
                    QueryResult result = twitter.search(query);
                    tweets.addAll(result.getTweets());
                    out.println("Gathered " + tweets.size() + " tweets"+"\n");
                    out.println("<br>");
                    out.println("<br>");
                    for (Status t: tweets)
                    {
                    if(t.getId() < lastID) 
                    lastID = t.getId();
                    }
                }

                catch (TwitterException te) 
                {
                    out.println("Couldn't connect: " + te);
                } 
                query.setMaxId(lastID-1);
            out.println("Error outside while");
            }
            out.print(lastID);

               //Database part
                String connectionURL = "jdbc:derby://localhost:1527/LINKS";
                Connection connection = null;
                Statement statement = null;
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            connection = DriverManager.getConnection(connectionURL,"root","root");
            statement = connection.createStatement();
                        
            for (int i = 0; i < tweets.size(); i++) 
            {
                Status t = (Status) tweets.get(i);
                GeoLocation loc = t.getGeoLocation();
                String user = t.getUser().getScreenName();
                String msg = t.getText();
                Date time = t.getCreatedAt();
                String time1=time.toString();
                int index=time1.lastIndexOf(' ');
                time1 = time1.substring(index+1);
                
             
            
               out.println("inside for loop");
                if (loc!=null) 
                    
                { 
                    Double lat = t.getGeoLocation().getLatitude();
                    Double lon = t.getGeoLocation().getLongitude();
                    
                    try
                    {
                     
                        
                        String SQL = "INSERT INTO ROOT.TWITTER(NAME,MESSAGE,LAT,LON,DATE) VALUES ('"+user+"','"+msg+"','"+lat+"','"+lon+"','"+time1+"')";
                        statement.executeUpdate(SQL);
                   out.println("Data eneterred sucessfully..!");
                        
                        System.out.println("Data eneterred sucessfully..!");
                    }
                    catch(Exception e)
                    {
                        System.out.print(e);
                    }
                
                }
                else {
                    
                    out.print("Else");
                    try
                    {
                        String SQL = "INSERT INTO ROOT.TWITTER(NAME,MESSAGE,DATE) VALUES ('"+user+"','"+msg+"','"+time1+"')";
                        statement.executeUpdate(SQL);
                               out.println("Data eneterred sucessfully..!");
                        System.out.println("Data eneterred sucessfully..!");
                    }
                    catch(Exception e)
                    {
                        System.out.print(e);
                    }
            }
            }
            
            
            
            Thread.sleep(10000);
            response.sendRedirect("sentiment.jsp");
        %>
    </body>
</html>