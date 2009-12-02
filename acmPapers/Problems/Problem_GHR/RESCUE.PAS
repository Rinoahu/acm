{$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V-,X+}
{$M 16384,0,655360}
program Rescue;
  const
    Infns='Input.txt';
    Outfns='Output.txt';
  type
    Tpath=array[0..10002] of byte;
  var
    N,K,A,M:word;
    pv,value,pt,time,arrive:array[1..50] of word;
    {value[i]��ʾ���Ϊi�Ķ���ļ�ֵ}
    {time[i]��ʾ���Ϊi��С���ĵĳ�ûʱ��} 
    {pv[i]��ʾ��ֵ��iС�Ķ����������(����value�����е��±�)}
    {pt[i]��ʾ��ûʱ�̵�iС��С���ı��}
    {arrive[i]���С��i��δ�����}
    animal:array[1..50,1..50] of word;
    {animal[i,j]��ʾС��i���ж��ٱ��Ϊj�Ķ���}
    path:array[1..30] of ^Tpath;
    {path[i]^��¼��i��Ƥ��ͧ���ж�·��}
    best:longint;
    {�ȳ��Ķ�����ܼ�ֵ}

  procedure ReadIn;{�������}
    var
      i,j:integer;
    begin
      assign(Input,Infns);
      reset(Input);
      readln(N,K,A);
      for i:=1 to A do
        read(value[i]);
      readln(M);
      for i:=1 to M do
        read(time[i]);
      for i:=1 to M do
        for j:=1 to A do
          read(animal[i,j]);
      close(Input);
    end;

  procedure Sort;{�Զ���ļ�ֵ���򣬲���С������ûʱ�̽�������}
    var
      i,j,p:integer;
    begin
      for i:=1 to A do
        pv[i]:=i;
      for i:=1 to A-1 do
        begin
          p:=i;
          for j:=i+1 to A do
            if value[pv[j]]<value[pv[p]] then p:=j;
          if i<>p then
            begin
              j:=pv[i]; pv[i]:=pv[p]; pv[p]:=j;
            end;
        end;
      for i:=1 to M do
        pt[i]:=i;
      for i:=1 to M-1 do
        begin
          p:=i;
          for j:=i+1 to M do
            if time[pt[j]]<time[pt[p]] then p:=j;
          if i<>p then
            begin
              j:=pt[i]; pt[i]:=pt[p]; pt[p]:=j;
            end;
        end;
    end;

  procedure GetNew;{ָ������ռ�}
    var
      i:integer;
    begin
      for i:=1 to N do
        begin
          new(path[i]);
          fillchar(path[i]^,sizeof(path[i]^),0);
        end;
    end;

  procedure Work;{ȷ��ÿһ��Ƥ��ͧ���ж�·��}
    var
      i,j,p,NowT,have,Max,start,free,temp:word;
      none:boolean;
    begin
      for i:=1 to N do
        begin
          NowT:=1; j:=0; Max:=A; start:=NowT; free:=K;
          fillchar(arrive,sizeof(arrive),0);{�����е����Ϊδ����ĵ�}
          repeat
            repeat
            {�ڵ�ǰʱ�̻�û��û��С���л����Ѿ��������С�����ҳ������ڼ�ֵ���Ķ���ĵ�}
              none:=true;
              for p:=1 to M do
                if ((time[pt[p]]>NowT) or (arrive[pt[p]]>=start))
                   and (animal[pt[p],pv[Max]]>0) then
                     begin none:=false; break; end;
              if none then dec(Max);
            until (not none) or (Max=0);
            if Max=0 then break;
            p:=pt[p];
            if arrive[p]<start then
            {����������Ϊ������ĵ�����ʱ�̼�1}
              begin
                arrive[p]:=NowT; path[i]^[NowT]:=p; inc(NowT);
              end;
            temp:=animal[p,pv[max]];
            if temp>=free
            {��������ϵļ�ֵ���Ķ��ﾡ��װ��Ƥ��ͧ�ϣ�����������Ϊ�ѵ���ĵ���
             Ƥ��ͧ��װ����ٶ�����Ͼ���Ӧ���ٶ��ٶ���}
                then begin
                       {���Ƥ��ͧ�Ѿ�װ�������ʻ�ذ�ȫ����ʱ�̼�1}
                       dec(animal[p,pv[max]],free);
                       inc(best,free*value[pv[max]]);
                       free:=k;
                       inc(NowT); start:=NowT;
                     end
                else begin
                       animal[p,pv[max]]:=0;
                       inc(best,temp*value[pv[max]]);
                       dec(free,temp);
                     end;
          until false;
        end;
    end;

  procedure Out;{�������}
    var
      i,j:integer;
    begin
      assign(Output,Outfns);
      rewrite(Output);
      writeln(best);
      for i:=1 to N do
        begin
          j:=0;
          repeat
            write(path[i]^[j],' ');
            inc(j);
          until (path[i]^[j]=0) and (path[i]^[j-1]=0);
          writeln;
        end;
      close(Output);
    end;

  begin
    ReadIn;{�������}
    Sort;{�Զ���ļ�ֵ���򣬲���С������ûʱ�̽�������}
    GetNew;{ָ������ռ�}
    Work;{ȷ��ÿһ��Ƥ��ͧ���ж�·��}
    Out;{�������}
  end.