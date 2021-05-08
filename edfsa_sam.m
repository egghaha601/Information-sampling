function[tt]=edfsa_sam(num_c,size_c,Sa,t_id, t_id2, t_inf)
            Mguding=num_c*size_c*Sa;
            Nguding=num_c*size_c*(1-Sa);
            T_all=Mguding+Nguding;
            Num_all=T_all;
            t2=0;
            B=zeros(1,T_all);
            for i=1:T_all
                B(i)=i;    %每个标签有自己的编号(假设为96位)，其中前M个为已知标签，后N个为未知标签
            end;
            while(T_all~=0)
                count=0;
                if T_all>4
                    f=round((T_all)/1);
                else
                    f=T_all;
                end;
                EV=zeros(1,f);
                AV=zeros(1,f);
                tag_sel=zeros(1,T_all);
                delete_uns=zeros(1,T_all); 
                k=0;
                
                for i=1:1:T_all
                    aaaa=unidrnd(f);
                    tag_sel(i)=aaaa;%产生1到f均匀分布的随机数，对应于各已知标签id映射的位置;
                end;
                x=unique(tag_sel);%不同元素个数
                y=tag_sel;
                [m1,n1]=hist(y,x); %m为n在Y中出现的次数
                for i=1:1:length(n1)
                    if n1(i)>0
                        AV(n1(i))=m1(i);
                    end;
                    if m1(i)>0
                        EV(n1(i))=1;
                    end;%EV为对应的1的时隙，EV1为对应的标签数量
                end;
                
                for i=1:1:f
                    if  AV(i)==1
                        count=count+1;  %记录消除的已知标签数
                        a=find(tag_sel==i); %找到映射到该时隙的标签下标
                        if sum(a)>0
                            for l=1:1:length(a)
                                e=B(a(l));
                                Num_all=Num_all-1;%一定是已知标签
                                delete_uns(k+1)=e;%记录该删除的已知标签，下一轮静墨
                                k=k+1;
                            end;
                        end;
                    end;
                end;
                
                delete=[delete_uns(1:k)];
                delete_re=zeros(1,length(delete));
                for i=1:1:length(delete)
                    delete_re(i)=find(B==delete(i));%找出该删除或者静默的标签在A中对应的下标
                end;
                B(delete_re(1:k))=[];
                t2=t2+f*t_id2+count*t_inf;
                T_all=Num_all;
            end
            tt=t2./1000000;
            