function stress=stress_Q9(Young,nu,tk,xe,ye,ue);

% [D] matrix for plane stress (isotropic material)
dmat=(Young/(1-nu^2))*[1 nu 0; nu 1 0; 0 0 (1-nu)/2];
% [D] matrix for plane strain (isotropic material)
%dmat=(Young/((1+nu)*(1-2*nu)))*[1-nu nu 0; nu 1-nu 0; 0 0 (1-2*nu)/2];

stress=zeros(4,3);
[ksi,wp]=int_gauss(2);
[eta,wq]=int_gauss(2);
pto=0;
for i=1:2
    for j=1:2
        N=shape_Q9(ksi(i),eta(j));
        dN=diff_shape_Q9(ksi(i),eta(j));
        Jacob=zeros(2,2);
        for inode=1:9
            Jacob=Jacob+dN(inode,:)'*[xe(inode) ye(inode)];
        end
        dNxy=dN*inv(Jacob)';
        B=[];
        for inode=1:9
            B=[B, [dNxy(inode,1) 0; 0 dNxy(inode,2); dNxy(inode,2) dNxy(inode,1)]];
        end
        pto=pto+1;
        stress(pto,:)=transpose(dmat*B*ue(1:18,1)*wp(i)*wq(j));
    end
end
    