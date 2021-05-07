 function[tt,bit_c,bit_uc]=acs_sam(num_c,size_c,Sa,t_id, t_id2, t_inf)
             Mguding=num_c*size_c*Sa;
             Nguding=num_c*size_c*(1-Sa);
             bit_com=0;
             bit_uncom=0;
             sumshu=Mguding+Nguding; %所有标签
             NumM=Mguding;
             NumN=Nguding;
             M=NumM;
             N=NumN;
             A=zeros(1,sumshu);
             t_com=0;
             t_uncom=0;
             for i=1:sumshu
                 A(i)=i;
             end;
             %---------------
             while(M>0)
                 tlongjishu=0;
                 f=M+N;
                 k=0;
                 AV1=zeros(1,f);
                 AV=zeros(1,f);
                 idresult1=zeros(1,M);
                 Nidresult1=zeros(1,M);
                 delete_sam=zeros(1,M);
                 %------
                 for i=1:1:M
                     aaaa=unidrnd(f);
                     idresult1(i)=aaaa;
                 end;
                 if N>0
                     for i=1:1:N
                         aaaa=unidrnd(f);
                         Nidresult1(i)=aaaa;%产生1到f均匀分布的随机数，对应于各已知标签id映射的位置;
                     end;
                 end;
                 result1=[idresult1,Nidresult1];
                 xa=unique(result1);%不同元素个数
                 ya=result1;
                 [ma1,na1]=hist(ya,xa); %m为n在Y中出现的次数
                 for i=1:1:length(na1)
                     if na1(i)>0
                         AV1(na1(i))=ma1(i);
                     end;
                 end;

                 for i=1:1:f
                     if AV1(i)>0
                         a=find(result1==i);
                         if length(a)==1
                             if A(a)<=Mguding %record the time slot selected by the sampled tags
                                 AV(i)=1;
                             end;
                         end;
                     end;
                 end;
                 w1=sum(AV);
                 if w1>0
                     for i=1:1:f
                         if AV(i)==1
                             tlongjishu=tlongjishu+1; %record the reproted sampled tags in each round
                             b=find(result1==i);
                             delete_sam(k+1)=b;
                             k=k+1;
                             NumM=NumM-1;
                         end;
                     end;
                     delete=[delete_sam(1:k),];
                     A(delete(1:length(delete)))=[];
                     num_group=zeros(1,2);
                     rat_group=zeros(1,2);
                     for i=1:1:f
                         if AV(i)==0
                             num_group(1)=num_group(1)+1;
                         else if AV(i)==1
                                 num_group(2)=num_group(2)+1;
                             end;
                         end;
                     end;

                     rat_group(1)=num_group(1)/f;
                     rat_group(2)=num_group(2)/f;
                     rat_group=sort(rat_group,'descend');
                     l_c=0;
                     for i=1:1:2
                         if rat_group(i)>0
                             l_c=l_c+rat_group(i)*log2(rat_group(i));
                         end;
                     end;
                     l_c=-l_c;
                     t_uncomsub=(f/96)*t_id+(tlongjishu)*t_inf;
                     t_comsub=(((1*l_c)*f)/96)*t_id+(tlongjishu)*t_inf;
                     bit_com=bit_com+ceil(l_c*f); 
                     bit_uncom=bit_uncom+f;        
                     t_com=t_com+t_comsub;
                     t_uncom=t_uncom+t_uncomsub;
                     M=NumM;
                 end;
             end;
             tt=t_com./1000000;%compressed
             tt2=t_uncom./1000000; %uncompressed
             bit_c=bit_com;
             bit_uc=bit_uncom;