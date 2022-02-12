<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page  import="java.awt.*" %>
<%@ page  import="java.io.*" %>
<%@ page  import="org.jfree.chart.*" %>
<%@ page  import="org.jfree.chart.entity.*" %>
<%@ page  import ="org.jfree.data.general.*"%>
<%@page import="java.sql.*" %>

<%
    String connectionURL = "jdbc:derby://localhost:1527/LINKS";
    Connection connection = null;
    Statement statement = null;
    ResultSet rs = null;
    int count_vnegative=0;
    int count_negative=0;
    int count_neutral=0;
    int count_positive=0;
    int count_vpositive=0;
    double percentage=0;
    int count=0;
    
    
        Class.forName("org.apache.derby.jdbc.ClientDriver").newInstance();
        connection = DriverManager.getConnection(connectionURL,"root","root");
        statement = connection.createStatement();
    try
    {
        
        
        String sql = "SELECT COUNT(SCORE) FROM ROOT.SENTIMENT WHERE SCORE='Negative'";
        rs=statement.executeQuery(sql);
        rs.next();
        count_negative = rs.getInt(1);
        
        String sql1 = "SELECT COUNT(SCORE) FROM ROOT.SENTIMENT WHERE SCORE='Neutral'";
        rs=statement.executeQuery(sql1);
        rs.next();
        count_neutral = rs.getInt(1);
        
        String sql2 = "SELECT COUNT(SCORE) FROM ROOT.SENTIMENT WHERE SCORE='Positive'";
        rs=statement.executeQuery(sql);
        rs.next();
        count_positive = rs.getInt(1);
        
       String sql3 = "SELECT COUNT(SCORE) FROM ROOT.SENTIMENT WHERE SCORE='Very Positive'";
        rs=statement.executeQuery(sql3);
        rs.next();
        count_vpositive = rs.getInt(1); 
        
        String sql4 = "SELECT COUNT(SCORE) FROM ROOT.SENTIMENT WHERE SCORE='Very Negative'";
        rs=statement.executeQuery(sql4);
        rs.next();
        count_vnegative = rs.getInt(1);
        
        String sql5 = "SELECT COUNT(*) FROM ROOT.SENTIMENT";
        rs=statement.executeQuery(sql);
        rs.next();
        count= rs.getInt(1);
        
        
    }
    catch(Exception e)
    {}
            
            final DefaultPieDataset data = new DefaultPieDataset();
            
            data.setValue("Negative", new Integer(count_negative));
            data.setValue("Neutral", new Integer(count_neutral));
            data.setValue("Positive", new Integer(count_positive));
            //data.setValue("Very Negative", new Integer(count_vnegative));
            //data.setValue("Very Positive", new Integer(count_vpositive));
            
            JFreeChart chart = ChartFactory.createPieChart("Pie Chart of Sentimental Analysis ", data, true, true, false);
            
            try 
            {
                final ChartRenderingInfo info = new 
                ChartRenderingInfo(new StandardEntityCollection()); 
                final File file1 = new File("C:/Users/Vekeshkumar/Documents/NetBeansProjects/Simple/web/WEB-INF/images/barchart.jpg");
                out.println(request.getContextPath()+"/images/barchart.png");
                ChartUtilities.saveChartAsJPEG(file1, chart, 600, 400, info);
            }
            catch (Exception e) 
            {
                out.println(e);
            }
            Thread.sleep(20000);
            response.sendRedirect("piechart1.jsp");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sentimental Analysis</title>
    </head>
    
</html> 