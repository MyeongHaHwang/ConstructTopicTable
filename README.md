# ConstructTopicTable

Language = Java

Function = Document Table in SQL -> Parsing the contents column in Document Table -> Implement LDA(1,1) -> Construct Topic Table in SQL

Files = ITU-T Recommendations (International Standards Documents of International Telecommunication Union)

1.Load Document Table in SQL

2.Parse the contents column in Document Table

3.Implement Latent Dirichlet Allocation(LDA) for extract the representative topic from each document

 - The number of cluster: 1
 
 - The number of iteration of algorithm: 1
 
 - Extract the top 10 word 
 
4.Set the strings to construct Topic Table in SQL

 - 1.series id (ex/ Y.3500)
 
 - 2.topic (ex/ cloud, data)
 
 - 3.dirichlet parameter = word counts in each cluster (ex/ 33, 54)
 
 - 4.occurrence rate = normalize the dirichlet parameter (ex/ 5%, 12%) <sum of occurrence rate = 100%)
 
5.Construct Topic Table 
 
Developer Contact: hmh929@kaist.ac.kr
