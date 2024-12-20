function index=eldof(iel,nnel,nodes,gdl)
% extração dos graus de liberdade do elemento iel
% reshape usado para que index fique um vetor linha
index=reshape(gdl(nodes(iel,:),:)',1,[]);

