function[tt,bit]=poll_sam(num_c,size_c,Sa,t_id, t_id2, t_inf)
                Mguding=num_c*size_c*Sa;
                Uguding=num_c*size_c*(1-Sa);
                T_uns=Uguding;
                T_s=Mguding;
                t_reader=T_s* t_id;
                t_tag=T_s* t_inf;
                tt=(t_reader+t_tag)./1000000;
                bit=T_s*96;

           