'TABLE-COLUMNS:

constituencywise_results - Party ID,  Constituency ID, Parliament Constituency, S.No, Constituency Name, Winning Candidate, Total Votes, Margin
statewise_results -  State ID, State, Parliament Constituency, Constituency, Const.No., Leading Candidate, Trailing Candidate, Margin, Status
constituencywise_details -  Constituency ID, Party, S.N., Candida,te, EVM Votes, Postal Votes, Total Votes, % of Votes
states - State ID, State
partywise_results - Party ID, Party, Won 

SELECT * FROM constituencywise_results
SELECT * FROM statewise_results
SELECT * FROM constituencywise_details
SELECT * FROM states
SELECT * FROM partywise_results'



                         'INDIA GENERAL ELECTIONS RESULT ANALYSIS 2024'


1) Total Seats

SELECT COUNT(DISTINCT("Parliament Constituency")) FROM constituencywise_results


2) What is the total number of seats available for elections in each state

SELECT COUNT(DISTINCT(cr."Parliament Constituency")) as total_seats, s."State"  FROM constituencywise_results AS cr
JOIN statewise_results AS sr ON sr."Parliament Constituency"=cr."Parliament Constituency"
JOIN states as s ON s."State ID"=sr."State ID"
GROUP BY 2


3) Total Seats Won by NDA Allianz

SELECT SUM(CASE WHEN "Party" IN (
'Bharatiya Janata Party - BJP', 
'Telugu Desam - TDP', 
'Janata Dal  (United) - JD(U)',
'Shiv Sena - SHS', 
'AJSU Party - AJSUP', 
'Apna Dal (Soneylal) - ADAL', 
'Asom Gana Parishad - AGP',
'Hindustani Awam Morcha (Secular) - HAMS',
'Janasena Party - JnP', 
'Janata Dal  (Secular) - JD(S)',
'Lok Janshakti Party(Ram Vilas) - LJPRV', 
'Nationalist Congress Party - NCP',
'Rashtriya Lok Dal - RLD', 
'Sikkim Krantikari Morcha - SKM'
) THEN "Won" 
ELSE 0
END) AS NDA
FROM partywise_results


4) Seats Won by NDA Allianz Parties

SELECT "Party","Won" FROM partywise_results
WHERE "Party" IN (
'Bharatiya Janata Party - BJP', 
'Telugu Desam - TDP', 
'Janata Dal  (United) - JD(U)',
'Shiv Sena - SHS', 
'AJSU Party - AJSUP', 
'Apna Dal (Soneylal) - ADAL', 
'Asom Gana Parishad - AGP',
'Hindustani Awam Morcha (Secular) - HAMS',
'Janasena Party - JnP', 
'Janata Dal  (Secular) - JD(S)',
'Lok Janshakti Party(Ram Vilas) - LJPRV', 
'Nationalist Congress Party - NCP',
'Rashtriya Lok Dal - RLD', 
'Sikkim Krantikari Morcha - SKM'
)
ORDER BY 2 DESC


5) Total Seats Won by I.N.D.I.A. Allianz

SELECT SUM(CASE WHEN "Party" IN (
'Indian National Congress - INC',
'Aam Aadmi Party - AAAP',
'All India Trinamool Congress - AITC',
'Bharat Adivasi Party - BHRTADVSIP',
'Communist Party of India  (Marxist) - CPI(M)',
'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
'Communist Party of India - CPI',
'Dravida Munnetra Kazhagam - DMK',
'Indian Union Muslim League - IUML',
'Nat`Jammu & Kashmir National Conference - JKN',
'Jharkhand Mukti Morcha - JMM',
'Jammu & Kashmir National Conference - JKN',
'Kerala Congress - KEC',
'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
'Rashtriya Janata Dal - RJD',
'Rashtriya Loktantrik Party - RLTP',
'Revolutionary Socialist Party - RSP',
'Samajwadi Party - SP',
'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
'Viduthalai Chiruthaigal Katchi - VCK'
) THEN "Won" ELSE 0 END) AS INDIA_Total_Seats_Won
FROM partywise_results


6) Add new column field in table partywise_results to get the Party Allianz as NDA, I.N.D.I.A and OTHER

ALTER TABLE partywise_results
ADD COLUMN party_allianz TEXT

UPDATE partywise_results
SET party_allianz='NDA'
WHERE "Party" IN (
'Bharatiya Janata Party - BJP', 
'Telugu Desam - TDP', 
'Janata Dal  (United) - JD(U)',
'Shiv Sena - SHS', 
'AJSU Party - AJSUP', 
'Apna Dal (Soneylal) - ADAL', 
'Asom Gana Parishad - AGP',
'Hindustani Awam Morcha (Secular) - HAMS',
'Janasena Party - JnP', 
'Janata Dal  (Secular) - JD(S)',
'Lok Janshakti Party(Ram Vilas) - LJPRV', 
'Nationalist Congress Party - NCP',
'Rashtriya Lok Dal - RLD', 
'Sikkim Krantikari Morcha - SKM'
)

UPDATE partywise_results
SET party_allianz='I.N.D.I.A'
WHERE "Party" IN (
'Indian National Congress - INC',
'Aam Aadmi Party - AAAP',
'All India Trinamool Congress - AITC',
'Bharat Adivasi Party - BHRTADVSIP',
'Communist Party of India  (Marxist) - CPI(M)',
'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
'Communist Party of India - CPI',
'Dravida Munnetra Kazhagam - DMK',
'Indian Union Muslim League - IUML',
'Nat`Jammu & Kashmir National Conference - JKN',
'Jharkhand Mukti Morcha - JMM',
'Jammu & Kashmir National Conference - JKN',
'Kerala Congress - KEC',
'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
'Rashtriya Janata Dal - RJD',
'Rashtriya Loktantrik Party - RLTP',
'Revolutionary Socialist Party - RSP',
'Samajwadi Party - SP',
'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
'Viduthalai Chiruthaigal Katchi - VCK'
)

UPDATE partywise_results
SET party_allianz='OTHER'
WHERE party_allianz IS NULL


7) Which party alliance (NDA, I.N.D.I.A, or OTHER) won the most seats across all states?

SELECT pr."party_allianz", COUNT(cr."Parliament Constituency") AS seat_won FROM partywise_results as pr 
JOIN constituencywise_results as cr ON pr."Party ID"= cr."Party ID"
GROUP BY 1
ORDER BY 2 DESC


8) Winning candidates name, their party name, total votes, and the margin of victory for a specific state and constituency?
 party_allianz "Margin"
SELECT cr."Constituency Name",s."State",cr."Winning Candidate",pr."party_allianz",cr."Total Votes",cr."Margin" FROM constituencywise_results as cr
JOIN partywise_results as pr ON pr."Party ID"=cr."Party ID" 
JOIN constituencywise_details as cd ON cd."Constituency ID"=cr."Constituency ID"
JOIN statewise_results as sr ON sr."Parliament Constituency"=cr."Parliament Constituency"
JOIN states AS s ON s."State ID"=sr."State ID"
--WHERE s."State" = 'Maharashtra'
GROUP BY 1,2,3,4,5,6


9) What is the distribution of EVM votes versus postal votes for candidates in a specific constituency?
SELECT cr."Constituency Name", cd."Candidate", cd."EVM Votes",cd."Postal Votes" FROM constituencywise_results as cr
JOIN constituencywise_details as cd ON cd."Constituency ID"=cr."Constituency ID"
--WHERE cr."Constituency Name" ILIKE'AgrA'
ORDER BY 1,3 DESC


10) Which parties won the most seats in s State, and how many seats did each party win?

WITH damn AS(
SELECT s."State",pr."Party",COUNT(cr."Winning Candidate") as total_seats FROM constituencywise_results as cr
JOIN partywise_results as pr ON pr."Party ID"=cr."Party ID" 
JOIN statewise_results as sr ON sr."Parliament Constituency"=cr."Parliament Constituency"
JOIN states AS s ON s."State ID"=sr."State ID"
GROUP BY 1,2
--ORDER  BY 1, 3 DESC
),
damn1 AS(
SELECT "State","Party", total_seats, ROW_NUMBER() OVER(PARTITION BY "State" ORDER BY total_seats DESC) FROM damn
)
SELECT "State","Party", total_seats, row_number FROM damn1
WHERE "row_number"='1'


11) What is the total number of seats won by each party alliance (NDA, I.N.D.I.A, and OTHER) in each state for the India Elections 2024

SELECT s."State",pr.party_allianz,COUNT(cr."Winning Candidate") total_seats FROM constituencywise_results as cr
JOIN partywise_results as pr ON pr."Party ID"=cr."Party ID" 
JOIN statewise_results as sr ON sr."Parliament Constituency"=cr."Parliament Constituency"
JOIN states AS s ON s."State ID"=sr."State ID"
--WHERE s."State"='Gujarat'
GROUP BY 1,2
ORDER BY 2, 3 DESC


12) Which candidate received the highest number of EVM votes in each constituency (Top 10)?

WITH damn AS(
SELECT cr."Constituency Name",cd."Candidate", cd."EVM Votes" FROM constituencywise_details as cd
JOIN constituencywise_results as cr ON cd."Constituency ID"=cr."Constituency ID"
ORDER BY 1, 3 DESC),
damn1 AS(
SELECT "Constituency Name", "Candidate", "EVM Votes", ROW_NUMBER() OVER(PARTITION BY "Constituency Name" ORDER BY "EVM Votes" DESC) as num FROM damn
)
SELECT "Constituency Name", "Candidate", "EVM Votes", num FROM damn1
WHERE num='1'
ORDER BY 3 DESC
LIMIT 10


13) Which candidate won and which candidate was the runner-up in each constituency of State for the 2024 elections?
 
WITH damn AS(
SELECT s."State", cr."Constituency Name", cd."Candidate", cd."Total Votes" FROM constituencywise_results AS cr
JOIN constituencywise_details AS cd ON cr."Constituency ID"=cd."Constituency ID"
JOIN statewise_results as sr ON sr."Parliament Constituency"=cr."Parliament Constituency"
JOIN states AS s ON s."State ID"=sr."State ID"
ORDER BY 1,4 DESC),
damn1 AS(
SELECT "State", "Constituency Name", "Candidate", "Total Votes",ROW_NUMBER() OVER(PARTITION BY "State" ORDER BY "Total Votes" DESC) as num FROM damn
),
damn2 AS(
SELECT "State", "Constituency Name", "Candidate", "Total Votes", num FROM damn1
WHERE num IN (1,2)
)
SELECT "State", "Constituency Name", "Candidate", "Total Votes", 
CASE WHEN num= '1' THEN 'Winner' ELSE '0' END as Winning_Candidate, CASE WHEN num='2' THEN 'Runner-up' ELSE '0' END as Runnerup_Candidate FROM damn2


14) For the state of Maharashtra, what are the total number of seats, total number of candidates, total number of parties, total votes (including EVM and postal), and the breakdown of EVM and postal votes?

SELECT s."State",COUNT(DISTINCT(cr."Winning Candidate")) as seats,COUNT(DISTINCT(cd."Candidate")) as candidates,COUNT(DISTINCT(cr."Party ID")) as winning_parties,SUM(cd."EVM Votes") as EVM,SUM(cd."Postal Votes") as Postal,SUM(cd."Total Votes") as Total FROM states as s
JOIN statewise_results as sr ON sr."State ID"=s."State ID"
JOIN constituencywise_results as cr ON cr."Parliament Constituency"=sr."Parliament Constituency"
JOIN constituencywise_details as cd ON cd."Constituency ID"=cr."Constituency ID"
GROUP BY 1
HAVING s."State"='Maharashtra'

