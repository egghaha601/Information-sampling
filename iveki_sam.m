function[tt]=iveki_sam(num_c,size_c,Sa,t_id, t_id2, t_inf)
            Mguding=num_c*size_c*Sa;
            Uguding=num_c*size_c*(1-Sa);
            T_uns=Uguding;
            T_s=Mguding;
            NumM=T_s;
            NumU=T_uns;
            lunshu=0;
            A=zeros(1,T_s+T_uns);
            wen=0;
            t1=0;
            tll=0;
            for i=1:T_s+T_uns Mguding=num_c*size_c*Sa;
            Uguding=num_c*size_c*(1-Sa);
                A(i)=i;%每个标签有自己的编号(假设为96位)，其中前M个为已知标签，后N个为未知标签
            end;
            while(T_uns>0)
                idresult1=zeros(1,T_s);
                Uidresult1=zeros(1,T_uns);%每一轮重新对已知标签和未知标签进行映射
                if T_s>2
                    f=round(Mguding);
                else
                    f=T_s;
                end;
                wen=wen+1;
                wen
                lunshu=lunshu+1;
                EV1=zeros(1,f);
                EV11=zeros(1,f);
                delete_uns=zeros(1,T_uns);
                for i=1:1:T_s
                    aaaa=unidrnd(f);
                    idresult1(i)=aaaa;%产生1到f均匀分布的随机数，对应于各已知标签id映射的位置;
                end;
                %----做了两次哈希映射
                x=unique(idresult1);%不同元素个数
                y=(idresult1);
                [m1,n1]=hist(y,x); %m为n在Y中出现的次数
                for i=1:1:T_uns
                    Uidresult1(i)=unidrnd(f);
                end; 
                result1=[idresult1,Uidresult1];
                xa=unique(result1);%不同元素个数
                ya=result1;
                [ma1,na1]=hist(ya,xa); %m为n在Y中出现的次数
                for i=1:1:length(na1)
                    if na1(i)>0
                        EV11(na1(i))=ma1(i);
                    end;    
                end;  
                result11=[idresult1,Uidresult1];
                EV111=zeros(1,f);
                for i=1:1:f
                    flag=0;
                    a=find(result1==i);
                    if length(a)>1
                        for z=1:1:length(a)
                            e=A(a(z));
                            if e>Mguding
                                flag=flag+1;
                            else flag=flag-1;
                            end;
                        end;
                        if (flag==length(a))%只有非关键标签
                            EV1(i)=1;
                        else
                            EV111(i)=0;%只有关键标签或混合的
                        end;
                    else if length(a)==1
                            e=A(a);
                            if e<=Mguding
                                EV1(i)=0;
                            else
                                EV1(i)=1;
                            end;
                        end;
                    end;
                end; 
                j=0;
                for i=1:1:f
                    if (EV1(i)==1)
                        a=find(result11==i);
                        if sum(a)>0
                            for zz=1:1:length(a)
                                e=a(zz);%A(a)对应于A中的第几个，e就是实际要删除的标签号
                                if A(e)>Mguding&&A(e)<=Mguding+Uguding
                                    delete_uns(j+1)=e;%记录A中该删除的已知标签的下标，下一轮静墨
                                    j=j+1;
                                end;
                            end;
                        end;
                    end;
                end;

                delete=[delete_uns(1:j)];
                A(delete(1:length(delete)))=[];
                EVt=(f/96);
                t1=t1+EVt*t_id;
                NumU=NumU-j;
                T_s=NumM;
                T_uns=NumU;
                tll=tll+EVt;
                
            end;
%-------------------------------------------------- collect information
                T_s=Mguding;
                T_uns=0;
                NumM=T_s;
                lunshu=0;
                A=zeros(1,T_s+T_uns);
                wen=0;
                t2=0;
                tll=0;
                for i=1:T_s+T_uns
                    A(i)=i;
                end;
                while(T_s~=0)
                    tlongjishu=0;
                    idresult1=zeros(1,T_s);
                    if T_s>2
                        f=round(T_s);
                    else
                        f=T_s;
                    end;
                    wen=wen+1;
                    lunshu=lunshu+1;
                    EV1=zeros(1,f);
                    EV11=zeros(1,f);
                    delete_s=zeros(1,T_s);
                    for i=1:1:T_s
                        aaaa=unidrnd(f);
                        idresult1(i)=aaaa;
                    end;
                    x=unique(idresult1);
                    y=(idresult1);
                    [m1,n1]=hist(y,x);
                    for i=1:1:length(n1)
                        if n1(i)>0
                            EV11(n1(i))=m1(i);
                        end;
                        if m1(i)==1
                            EV1(n1(i))=1;
                        end;
                    end;
                    k=0;
                    for i=1:1:f
                        if (EV1(i)==1)
                            tlongjishu=tlongjishu+1;
                            b=find(idresult1==i);
                            delete_s(k+1)=b;
                            NumM=NumM-1;
                        end;
                    end;
                    delete=[delete_s(1:k)];
                    A(delete(1:length(delete)))=[]; 
                    EVt=(f/96+1);
                    t2=t2+EVt*t_id+tlongjishu*t_inf;
                    T_s=NumM;
                    tll=tll+EVt; 
                end;
                tt=(t1+t2)./1000000;
