function k=stif_Q9(Young,nu,tk,xe,ye);

% [D] matrix for plane stress (isotropic material)
dmat=(Young/(1-nu^2))*[1 nu 0; nu 1 0; 0 0 (1-nu)/2];
% [D] matrix for plane strain (isotropic material)
%dmat=(Young/((1+nu)*(1-2*nu)))*[1-nu nu 0; nu 1-nu 0; 0 0 (1-2*nu)/2];


k=zeros(2*9,2*9);
[ksi,wp]=int_gauss(3);
[eta,wq]=int_gauss(3);
for i=1:3
    for j=1:3
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
        k=k+B'*dmat*B*tk*det(Jacob)*wp(i)*wq(j);
    end
end
    