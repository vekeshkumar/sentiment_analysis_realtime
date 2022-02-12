import edu.stanford.nlp.ling.CoreAnnotations;
import edu.stanford.nlp.neural.rnn.RNNCoreAnnotations;
import edu.stanford.nlp.pipeline.Annotation;
import edu.stanford.nlp.pipeline.StanfordCoreNLP;
import edu.stanford.nlp.sentiment.SentimentCoreAnnotations;
import edu.stanford.nlp.trees.Tree;
import edu.stanford.nlp.util.CoreMap;
import java.sql.*;
import java.util.Properties;


public class NLP 
{
    static StanfordCoreNLP pipeline;
    
    public static void init() 
    {
        pipeline = new StanfordCoreNLP("My.properties");
    }
    public static void findSentiment()
    {
         
        String tweet="null";
        int mainSentiment = 0;
        int longest = 0;
        int sentiment;
        String partText;
        
        String connectionURL = "jdbc:derby://localhost:1527/LINKS";
        Connection connection = null;
        Statement statement = null;
        ResultSet rs = null;
        
        try
        {
            Class.forName("org.apache.derby.jdbc.ClientDriver").newInstance();
            connection = DriverManager.getConnection(connectionURL,"root","root");
            statement = connection.createStatement();
            String SQL = "SELECT MESSAGE FROM ROOT.TWITTER";
            rs=statement.executeQuery(SQL);
            while (rs.next()) 
            {
                tweet=rs.getString("URL");
                if (tweet != null && tweet.length() > 0) 
                {
                    Annotation annotation = pipeline.process(tweet);
                    for (CoreMap sentence : annotation.get(CoreAnnotations.SentencesAnnotation.class)) 
                    {
                        Tree tree = sentence.get(SentimentCoreAnnotations.SentimentAnnotatedTree.class);
                        sentiment = RNNCoreAnnotations.getPredictedClass(tree);
                        partText = sentence.toString();
                        if (partText.length() > longest) 
                        {
                            mainSentiment = sentiment;
                            longest = partText.length();
                            System.out.println(mainSentiment);
                            System.out.println("\n");
                        } //2nd if statement
                    }//for loop
                }//1st if statement  
             }//while loop
            
        }//try
        catch(Exception e)
        {
            
        }
    }   
}   

