<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="javax.servlet.*"%>

<%@ page import="java.io.*"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.BufferedWriter"%>
<%@ page import="java.io.FileReader"%>
<%@ page import="java.io.FileWriter"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>

<%@ page import="java.util.*"%>
<%@ page import="java.util.Scanner"%>
<%@ page import="java.util.Vector"%>

<%@ page import="edu.yonsei.util.*"%>
<%@ page import="edu.yonsei.util.Collection"%>
<%@ page import="edu.yonsei.util.Document"%>
<%@ page import="edu.yonsei.util.Topic"%>
<%@ page import="edu.yonsei.test.main.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en-US">
<head>
<!-- ==============================================
        Title and basic Metas
        =============================================== -->
<meta charset="utf-8">
<title>International Standard Web Service</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="description"
	content="International Standard Web Service by ETRI">
<meta name="author" content="Myeong-ha Hwang">

<!-- ==============================================
        Mobile Metas
        =============================================== -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- ==============================================
        Fonts and CSS
        =============================================== -->
<link href="http://fonts.googleapis.com/css?family=Quicksand"
	rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Open+Sans"
	rel="stylesheet" type="text/css">
<link href="css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="css/style.css" rel="stylesheet" type="text/css">


</head>
<body>
	<div class="wrapper">
		<div id="ascensor">
			<section class="section client">
			<div class="container">
				<h1 class="h1">Topic Modeling by Series</h1>
				<!-- fix element-->
				<h2 class="h2">Y : Global information infrastructure, Internet
					protocol aspects and next-generation networks</h2>

				<!-- table start-->
				<center>
					<table width="70%" border="1">
						<thead>
							<tr>
								<th>Number</th>
								<!-- the name of first column  -->
								<th>Topic(Score)</th>
								<!-- the name of second column -->
							</tr>
						</thead>
						<tbody>
							<%
								//Database Connection
								Connection con = null;
								PreparedStatement pstmt = null;
								ResultSet rs = null;

								PreparedStatement pstmt_t = null;
								ResultSet rs_t = null;

								String series_id = null;
								String topic_0 = null;
								double score = 0;
								double score_total = 0;
								double percent = 0;

								String series_id_t = null;
								String topic_0_t = null;
								double score_t = 0;
								double score_total_t = 0;
								double precent_t = 0;

								ArrayList<String> topic_list = new ArrayList<String>();
								ArrayList<Double> score_list = new ArrayList<Double>();
								ArrayList<Double> percent_list = new ArrayList<Double>();
								ArrayList<Integer> score_list_result = new ArrayList<Integer>(); //** end

								Document document;
								Topic topic;
								Class.forName("com.mysql.jdbc.Driver");
								String jdbcUrl = "jdbc:mysql://localhost:3306/trend"; //DB name
								String id = "root"; //DB id
								String pass = "1234"; //DB pw

								//connect the trend table (id = root / pw = 1234)
								con = DriverManager.getConnection("jdbc:mysql://localhost:3306/trend", "root", "1234");

								//select the detailed value of table
								//pstmt = con.prepareStatement("select * from doc_table where series_id = 'E.100'");
								//String SI = "E.100";

								//pstmt = con.prepareStatement("select * from doc_table");

								pstmt_t = con.prepareStatement("select * from doc_table where series_id like 'Y%'");
								rs_t = pstmt_t.executeQuery();

								while (rs_t.next()) {
									String Series_Id = rs_t.getString("series_id");
									pstmt = con.prepareStatement("select * from doc_table where series_id= '" + Series_Id + "'");
									String SI = Series_Id;

									//pstmt = con.prepareStatement("select * from doc_table where series_id = 'Y.3500' or series_id = 'Y.3501'");
									//This use <preparedstatement setString>

									//execute the Query & create LDA
									rs = pstmt.executeQuery();

									String str = null;
									Vector<String> list = new Vector<String>();
									while (rs.next()) {
										//print the selected values on Console 
										System.out.println(rs.getString("value"));
										str = rs.getString("value");
										list.add(str);
									}

									//input the selected values to Collection / create the LDA Algorithm (Cluster=1, Iteration=1000)
									//LDA is EM Algorithm
									//if iteration is high, accuracy also be high
									Collection collection = new Collection(list);
									collection.createLDA(1, 100);
									for (int i = 0; i < 1; i++) {
										int idx = (int) (Math.random() * collection.size());
										document = collection.get(idx);
										topic = document.getTopic("model/mallet/");
									}

									//print the "TOPICS: " on Console
									System.out.println("TOPICS: ");
									Topic[] topics = collection.getTopics();

									//print the topics on Console
									for (int i = 0; i < 1; i++)
										System.out.println(topics[i]);

									//save the topics in text file because of slicing topics
									PrintWriter writer2 = new PrintWriter(
											"C:/pyTest/TrendJSP/WebContent/WEB-INF/yTextMiner/data/corpus/result_topics_test2.txt",
											"UTF-8");
									for (int d = 0; d < 1; d++)
										writer2.println(topics[d]);
									writer2.close();

									//read the text file
									String txtFilePath = "C:/pyTest/TrendJSP/WebContent/WEB-INF/yTextMiner/data/corpus/result_topics_test2.txt";
									BufferedReader reader = new BufferedReader(new FileReader(txtFilePath));
									String line = reader.readLine();
									int lineCnt = 1; //line count
									//lineCnt is maximum line in text
									while (reader.readLine() != null) {
										lineCnt++;
									}

									for (int p = 0; p < lineCnt; p++) {
							%>
							<tr>
								<th>
									<%
										out.println(p);
									%>
								</th>

								<!-- hyper link to Series_Sub2.jsp -->
								<th><a href="/TrendJSP/Series_Sub2.jsp"> <%
 	//input topics[p] to the Temp_Topic
 			String Temp_Topic = topics[p].toString();
 			String[] Temp_Split = new String[100];
 			//split the topics by " "
 			Temp_Split = Temp_Topic.split(" ");
 			//print the topics on the Web-Page
 			for (int q = 0; q < 2; q++) {
 				if (q % 2 != 0 && 5 != 0) {
 					//1. words is odd number of in text
 					//2. score is even number of in text
 					out.println(Temp_Split[1]);
 					for (int nn = 0; nn < 1; nn++) {
 						//for (int nn = 0; nn < 20; nn++){
 						//if (Temp_Split[q + nn] == "(") {
 						//System.out.println(Temp_Split[q + nn]);
 						String Score_Value = Temp_Split[q + 1];
 						//Score_Value.substring(2, Score_Value.length()-1);
 						System.out.println(Score_Value.substring(1, Score_Value.length() - 1)); //356.00
 						System.out.println(Temp_Split[q]); //cloud
 						System.out.println(Temp_Split[q + 1]); //(356.00)
 						System.out.println(Temp_Split[q + 2]); //service
 						System.out.println(Temp_Split[q + 3]); //(273.00)

 						String Score_StoI_Percent_0 = Temp_Split[q + 1].substring(1,
 								Temp_Split[q + 1].length() - 4);
 						double Score_Set_Double_Percent_0 = Double.parseDouble(Score_StoI_Percent_0);

 						String Score_StoI_Percent_1 = Temp_Split[q + 3].substring(1,
 								Temp_Split[q + 3].length() - 4);
 						double Score_Set_Double_Percent_1 = Double.parseDouble(Score_StoI_Percent_1);

 						String Score_StoI_Percent_2 = Temp_Split[q + 5].substring(1,
 								Temp_Split[q + 5].length() - 4);
 						double Score_Set_Double_Percent_2 = Double.parseDouble(Score_StoI_Percent_2);

 						String Score_StoI_Percent_3 = Temp_Split[q + 7].substring(1,
 								Temp_Split[q + 7].length() - 4);
 						double Score_Set_Double_Percent_3 = Double.parseDouble(Score_StoI_Percent_3);

 						String Score_StoI_Percent_4 = Temp_Split[q + 9].substring(1,
 								Temp_Split[q + 9].length() - 4);
 						double Score_Set_Double_Percent_4 = Double.parseDouble(Score_StoI_Percent_4);

 						String Score_StoI_Percent_5 = Temp_Split[q + 11].substring(1,
 								Temp_Split[q + 11].length() - 4);
 						double Score_Set_Double_Percent_5 = Double.parseDouble(Score_StoI_Percent_5);

 						String Score_StoI_Percent_6 = Temp_Split[q + 13].substring(1,
 								Temp_Split[q + 13].length() - 4);
 						double Score_Set_Double_Percent_6 = Double.parseDouble(Score_StoI_Percent_6);

 						String Score_StoI_Percent_7 = Temp_Split[q + 15].substring(1,
 								Temp_Split[q + 15].length() - 4);
 						double Score_Set_Double_Percent_7 = Double.parseDouble(Score_StoI_Percent_7);

 						String Score_StoI_Percent_8 = Temp_Split[q + 17].substring(1,
 								Temp_Split[q + 17].length() - 4);
 						double Score_Set_Double_Percent_8 = Double.parseDouble(Score_StoI_Percent_8);

 						String Score_StoI_Percent_9 = Temp_Split[q + 19].substring(1,
 								Temp_Split[q + 19].length() - 4);
 						double Score_Set_Double_Percent_9 = Double.parseDouble(Score_StoI_Percent_9);

 						System.out.println("score_list : start");
 						score_list.add(Score_Set_Double_Percent_0);
 						score_list.add(Score_Set_Double_Percent_1);
 						score_list.add(Score_Set_Double_Percent_2);
 						score_list.add(Score_Set_Double_Percent_3);
 						score_list.add(Score_Set_Double_Percent_4);
 						score_list.add(Score_Set_Double_Percent_5);
 						score_list.add(Score_Set_Double_Percent_6);
 						score_list.add(Score_Set_Double_Percent_7);
 						score_list.add(Score_Set_Double_Percent_8);
 						score_list.add(Score_Set_Double_Percent_9);
 						System.out.println(score_list);
 						System.out.println("score_list : end");

 						for (int i = 0; i < score_list.size(); i++) {
 							score_total += score_list.get(i);

 						}
 						System.out.println("score_total :" + score_total);

 						for (int j = 0; j < score_list.size(); j++) {
 							double score_test = (score_list.get(j) * 100) / score_total;

 							double real_value = Math.round(score_test * 100d) / 100d;
 							//System.out.println(real_value);

 							percent_list.add(real_value);
 						}
 						System.out.println(percent_list);

 						// the mysql insert statement

 						String query = "insert into doc_topic (series_id, topic, score, percent)"
 								+ "values(?,?,?,?)";
 						//1
 						PreparedStatement preparedStmt = con.prepareStatement(query);
 						preparedStmt.setString(1, SI); //Y.3500
 						preparedStmt.setString(2, Temp_Split[q]); //TOPIC
 						String Score_StoI = Temp_Split[q + 1].substring(1, Temp_Split[q + 1].length() - 4); //SCORE : string
 						int Score_Set_Int = Integer.parseInt(Score_StoI); //SCORE : string -> int
 						preparedStmt.setInt(3, Score_Set_Int); //SCORE : int
 						preparedStmt.setDouble(4, percent_list.get(0));
 						preparedStmt.execute();
 						//2
 						preparedStmt.setString(1, SI);
 						preparedStmt.setString(2, Temp_Split[q + 2]);
 						String Score_StoI2 = Temp_Split[q + 3].substring(1, Temp_Split[q + 3].length() - 4);
 						int Score_Set_Int2 = Integer.parseInt(Score_StoI2);
 						preparedStmt.setInt(3, Score_Set_Int2);
 						preparedStmt.setDouble(4, percent_list.get(1));
 						preparedStmt.execute();
 						//3
 						preparedStmt.setString(1, SI);
 						preparedStmt.setString(2, Temp_Split[q + 4]);
 						String Score_StoI3 = Temp_Split[q + 5].substring(1, Temp_Split[q + 5].length() - 4);
 						int Score_Set_Int3 = Integer.parseInt(Score_StoI3);
 						preparedStmt.setInt(3, Score_Set_Int3);
 						preparedStmt.setDouble(4, percent_list.get(2));
 						preparedStmt.execute();
 						//4
 						preparedStmt.setString(1, SI);
 						preparedStmt.setString(2, Temp_Split[q + 6]);
 						String Score_StoI4 = Temp_Split[q + 7].substring(1, Temp_Split[q + 7].length() - 4);
 						int Score_Set_Int4 = Integer.parseInt(Score_StoI4);
 						preparedStmt.setInt(3, Score_Set_Int4);
 						preparedStmt.setDouble(4, percent_list.get(3));
 						preparedStmt.execute();
 						//5
 						preparedStmt.setString(1, SI);
 						preparedStmt.setString(2, Temp_Split[q + 8]);
 						String Score_StoI5 = Temp_Split[q + 9].substring(1, Temp_Split[q + 9].length() - 4);
 						int Score_Set_Int5 = Integer.parseInt(Score_StoI5);
 						preparedStmt.setInt(3, Score_Set_Int5);
 						preparedStmt.setDouble(4, percent_list.get(4));
 						preparedStmt.execute();
 						//6
 						preparedStmt.setString(1, SI);
 						preparedStmt.setString(2, Temp_Split[q + 10]);
 						String Score_StoI6 = Temp_Split[q + 11].substring(1, Temp_Split[q + 11].length() - 4);
 						int Score_Set_Int6 = Integer.parseInt(Score_StoI6);
 						preparedStmt.setInt(3, Score_Set_Int6);
 						preparedStmt.setDouble(4, percent_list.get(5));
 						preparedStmt.execute();
 						//7
 						preparedStmt.setString(1, SI);
 						preparedStmt.setString(2, Temp_Split[q + 12]);
 						String Score_StoI7 = Temp_Split[q + 13].substring(1, Temp_Split[q + 13].length() - 4);
 						int Score_Set_Int7 = Integer.parseInt(Score_StoI7);
 						preparedStmt.setInt(3, Score_Set_Int7);
 						preparedStmt.setDouble(4, percent_list.get(6));
 						preparedStmt.execute();
 						//8
 						preparedStmt.setString(1, SI);
 						preparedStmt.setString(2, Temp_Split[q + 14]);
 						String Score_StoI8 = Temp_Split[q + 15].substring(1, Temp_Split[q + 15].length() - 4);
 						int Score_Set_Int8 = Integer.parseInt(Score_StoI8);
 						preparedStmt.setInt(3, Score_Set_Int8);
 						preparedStmt.setDouble(4, percent_list.get(7));
 						preparedStmt.execute();
 						//9
 						preparedStmt.setString(1, SI);
 						preparedStmt.setString(2, Temp_Split[q + 16]);
 						String Score_StoI9 = Temp_Split[q + 17].substring(1, Temp_Split[q + 17].length() - 4);
 						int Score_Set_Int9 = Integer.parseInt(Score_StoI9);
 						preparedStmt.setInt(3, Score_Set_Int9);
 						preparedStmt.setDouble(4, percent_list.get(8));
 						preparedStmt.execute();
 						//10
 						preparedStmt.setString(1, SI);
 						preparedStmt.setString(2, Temp_Split[q + 18]);
 						String Score_StoI10 = Temp_Split[q + 19].substring(1, Temp_Split[q + 19].length() - 4);
 						int Score_Set_Int10 = Integer.parseInt(Score_StoI10);
 						preparedStmt.setInt(3, Score_Set_Int10);
 						preparedStmt.setDouble(4, percent_list.get(9));
 						preparedStmt.execute();

 						//}
 					}

 					//out.println(Temp_Split[1]+" / "+Temp_Split[3]);

 					//Number : The Dirichlet parameter for the topic

 					//This gives an indication of the weight of that topic.
 					//In general, including "-optimize-interval" leads to better topics
 				}
 			}
 		}
 		score_total = 0;
 		score_list.clear();
 		percent_list.clear();
 	}
 %>
								</a></th>
							</tr>
					</table>
				</center>
			</div>
			</section>
			<!-- /about -->
		</div>
		<!-- /ascensor -->
	</div>
	<!-- /wrapper -->
</body>
</html>
