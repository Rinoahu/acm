{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V-,X+,Y+}
{$M 16384,0,655360}
program CamelTrading;
const
	MaxN=100;	{N������}
var
	N	:byte;	{ͼ�е���N}
	Value	:array [1..MaxN,1..MaxN] of word;	{���ϵ�Ȩ}
	Degree,		{��Ķ���}
	Destination	:array [1..MaxN] of byte;	{ÿ�������̶ӵ�Ŀ�ĵ�}

procedure ReadIn;	{����}
var
	M	:word;	{ͼ�еı���}
	i,j	:byte;
	k,v	:word;
begin
	reset(input);
	readln(N,M);
	fillchar(Degree,sizeof(Degree),0);
	for k:=1 to M do
	begin
		readln(i,j,v);
		Value[i,j]:=v;
		Value[j,i]:=v;
		inc(Degree[i]);
		inc(Degree[j]);
	end;
	close(input);
end;

procedure DeleteEdge(u,v:byte);	{ɾȥ��(u,v)}
begin
	Value[u,v]:=0;
	Value[v,u]:=0;
	dec(Degree[u]);
	dec(Degree[v]);
end;

procedure DealOneDegree;	{�������ж�Ϊ1�ĵ�}
var
	i,j	:byte;
	ok	:boolean;
begin
	repeat
		ok:=true;
		for i:=1 to N do
			if Degree[i]=1 then
			begin
				for j:=1 to N do
					if Value[i,j]>0 then
						break;
				Destination[i]:=j;	{����(i,j)�����i}
				DeleteEdge(i,j);
				if (j<i) and (Degree[j]=1) then
					ok:=false;
			end;
	until ok;
end;

procedure Work;	{������}
var
	u,v,i	:byte;
	Mark	:array [1..MaxN] of boolean;	{������ͨ����ʱ�õ��ı�־}
	SubM,SubN,	{��ͨ�����еı����͵���}
	MinV	:word;	{��ͨ��������С��Ȩ}
	procedure DFS(k:byte);	{�������������ͨ����}
	var	i:byte;
	begin
		Mark[k]:=false;
		inc(SubN); inc(SubM,Degree[k]);
		for i:=1 to N do
			if Value[k,i]>0 then
			begin
				if Value[k,i]<MinV then
				begin
					MinV:=Value[k,i];
					u:=k; v:=i;
				end;
				if Mark[i] then
					DFS(i);
			end;
	end;
begin
	repeat
		DealOneDegree;
		for u:=1 to N do
			if Degree[u]>0 then
				break;
		if Degree[u]=0 then break;	{���ͼ����û�б���������㷨}
		fillchar(Mark,sizeof(Mark),true);
		SubM:=0; SubN:=0;
		MinV:=high(MinV);
		DFS(u);	{����������SubMʵ�����Ǳ���*2}
		if SubM=SubN+SubN	{����������ڵ���}
		then for i:=1 to SubN do	{ȡ�����еı�}
			begin
				for v:=1 to N do
					if Value[u,v]>0 then
						break;
				Destination[u]:=v;
				DeleteEdge(u,v);
				u:=v;
			end
		else DeleteEdge(u,v);	{ɾ��Ȩ��С�ı�}
	until false;
end;

procedure Print;	{��ӡ}
var
	i	:byte;
begin
	rewrite(output);
	for i:=1 to N do
		write(Destination[i],' ');
	writeln;
	close(output);
end;

begin
	assign(input,'input.txt');
	assign(output,'output.txt');
	ReadIn;
	Work;
	Print;
end.