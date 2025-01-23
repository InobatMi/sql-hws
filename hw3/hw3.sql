select * from (
SELECT *, lag([Total_Marks], 1) over (partition by [Student_Name] order by [Year]) as [Prev_Marks] FROM [TSQL2012].[dbo].[Student] 
) as A
where A.[Prev_Marks] is not null and A.[Total_Marks] >= A.[Prev_Marks]


Create Table Match_Result (
Team_1 Varchar(20),
Team_2 Varchar(20),
Result Varchar(20)
)

Insert into Match_Result Values('India', 'Australia','India');
Insert into Match_Result Values('India', 'England','England');
Insert into Match_Result Values('SouthAfrica', 'India','India');
Insert into Match_Result Values('Australia', 'England',NULL);
Insert into Match_Result Values('England', 'SouthAfrica','SouthAfrica');
Insert into Match_Result Values('Australia', 'India','Australia');

select A.Team_1, 
			count(*) as match_played, 
			B.match_won, 
			ISNULL(C.match_tied, 0) as match_tied, 
			count(*) - B.match_won - ISNULL(C.match_tied, 0) as match_lost from (
select Team_1 from Match_Result
union all
select Team_2 from Match_Result ) as A
inner join (
select Team_1, count(Result) as match_won from Match_Result
group by Team_1 ) as B on A.Team_1=B.Team_1
left join (
select Team_1, count(*) as match_tied from Match_Result
where result is null
group by Team_1
union all 
select Team_2, count(*) as match_tied from Match_Result
where result is null
group by Team_2 ) as C on A.Team_1 = C.Team_1
group by A.Team_1, B.match_won, C.match_tied