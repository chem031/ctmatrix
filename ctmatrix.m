clear all;
close all;


choice = menu("Choose data type", "CBasketball '16-'17","CBaseball '16"
,"NFL '16","NHL '16-'17","NBA '16-'17","MLB '16", "FBS '16","Other")
choice

if (choice==1)
    gamefile='cbb2017data.csv';
    teamfile='cbb2017teams.csv';
    outfile='cbb2017rank';
    #conffile='basketball2015-16confs.csv';
    #[cfindex,cfnames]=textread(conffile,'%d,%s');
    choice
endif

if (choice==2)
      gamefile='baseball2016data.csv';
      teamfile='baseball2016teams.csv';
      outfile='baseball2016rank';
      choice
endif

if (choice==3)
  gamefile='nfl2016data.csv';
  teamfile='nfl2016teams.csv';
  outfile='nfl2016rank';
  choice
endif

if (choice==4)
  gamefile='nhl2017data.csv';
  teamfile='nhl2017teams.csv';
  outfile='nhl2017rank';
  choice
endif


if (choice==5)
  gamefile='nba2017data.csv';
  teamfile='nba2017teams.csv';
  outfile='nba2017rank';
  choice
endif

if (choice==6)
  gamefile='mlb2016data.csv';
  teamfile='mlb2016teams.csv';
  outfile='mlb2016rank';
  choice
endif

if (choice==7)
  gamefile='fbs2016data.csv';
  teamfile='fbs2016teams.csv';
  outfile='fbs2016rank';
  choice
endif


if (choice==8)
  gamefile=input('gamefile?',"s");
  teamfile=input('teamfile?',"s");
  outfile=input('outfile?',"s");
  choice
endif


games=csvread(gamefile);
[tmindex,tmnames]=textread(teamfile,'%d,%s');


b = zeros(length(tmindex),1);
A = zeros(length(tmindex));

for n=1:length(tmindex)
    A(n,n)=2;
  
end



for m=1:length(games)
    score = games(m,5)-games(m,8);    
    A(games(m,3),games(m,3)) = A(games(m,3),games(m,3)) + 1;
    A(games(m,6),games(m,6)) = A(games(m,6),games(m,6)) + 1;
    A(games(m,3),games(m,6)) = A(games(m,3),games(m,6)) - 1;
    A(games(m,6),games(m,3)) = A(games(m,6),games(m,3)) - 1;
    b(games(m,3)) = b(games(m,3)) + log(score+1);
    b(games(m,6)) = b(games(m,6)) - log(score+1);
   
end

if (choice==2 || choice==4 || choice==6)
  for m=1:length(games)
    score = games(m,5)-games(m,8);    
    A(games(m,3),games(m,3)) = A(games(m,3),games(m,3)) + 1;
    A(games(m,6),games(m,6)) = A(games(m,6),games(m,6)) + 1;
    A(games(m,3),games(m,6)) = A(games(m,3),games(m,6)) - 1;
    A(games(m,6),games(m,3)) = A(games(m,6),games(m,3)) - 1;
    b(games(m,3)) = b(games(m,3)) + log(score*3.5+1);
    b(games(m,6)) = b(games(m,6)) - log(score*3.5+1);

  end
endif
t = (A^-1)*b;


if (choice==7)
weight = (6-min(input('week?'),6))/6;
[tmaverage,tmnames] = textread('fbs12-16avg.csv','%f,%s');
t = t.*(1-weight) + tmaverage.*weight;
endif

if (choice==1)
weight = (4-min(input('week?'),4))/4;
[tmaverage,tmnames] = textread('cbb12-16avg.csv','%f,%s');
t = t.*(1-weight) + tmaverage.*weight;
endif
  
for n=1:length(t)
    t(n,2)=n;
   
end

T = cell(size(t));

for n=1:length(T)
    T{n,1}=t(n);
    T{n,2}=tmnames(n);
   
end


outputfile=strcat(outfile, date(), ".csv");
outfile
outputfile
csvwrite(outputfile,t);
