function k=stif_T6(Young,nu,tk,xe,ye)

% [D] matrix for plane stress (isotropic material)
dmat=(Young/(1-nu^2))*[1 nu 0; nu 1 0; 0 0 (1-nu)/2];
% [D] matrix for plane strain (isotropic material)
%dmat=(Young/((1+nu)*(1-2*nu)))*[1-nu nu 0; nu 1-nu 0; 0 0 (1-2*nu)/2];

nos_por_elemento = 6;

k=zeros(2*6,2*6); % Isto é 2 graus de liberdade * nr de nos, substituir 9
% pelo nosso nr de nos
[ksi,wp,eta]=int_gauss_T6(3);
wq = wp;
for i=1:3
    for j=1:3
        N=shape_T6(ksi(i),eta(j));
        dN=diff_shape_T6(ksi(i),eta(j));
        Jacob=zeros(2,2);
        for inode=1:nos_por_elemento
            Jacob=Jacob+dN(inode,:)'*[xe(inode) ye(inode)];
        end
        dNxy=dN*inv(Jacob)';
        B=[];
        for inode=1:nos_por_elemento
            B=[B, [dNxy(inode,1) 0; 0 dNxy(inode,2); dNxy(inode,2) dNxy(inode,1)]];
        end
        k=k+B'*dmat*B*tk*det(Jacob)*wp(i)*wq(j);
    end
end
    