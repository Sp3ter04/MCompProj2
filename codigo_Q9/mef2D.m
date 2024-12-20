% Programa de elementos finitos para elementos 2D
% Exemplo para o elemento Q9 em elasticidade 2D
%
clear all
close all
%
nnel=9; % numero de nos por elemento
%
%ndof= numero de graus de liberdade por no
ndof=2; %para problemas de elasticidade 2D
%
% numero de nos e elementos da malha
nnode=45;
nelem=8;
sdof=ndof*nnode; % numero total de graus de liberdade na malha
%
% coordenadas nodais da malha
gcoord(1:9,1)=[0:0.125:1];
gcoord(10:18,1)=[0:0.125:1];
gcoord(19:27,1)=[0:0.125:1];
gcoord(28:36,1)=[0:0.125:1];
gcoord(37:45,1)=[0:0.125:1];
gcoord(1:9,2)=0;
gcoord(10:18,2)=0.125;
gcoord(19:27,2)=0.250;
gcoord(28:36,2)=0.375;
gcoord(37:45,2)=0.5;
%
%
% conectividades nodais dos elementos
% nodes(elemento,no local)

nodes(1,:)=[1 3 21 19 2 12 20 10 11];
nodes(2,:)=nodes(1,:)+2*ones(1,9);
nodes(3,:)=nodes(2,:)+2*ones(1,9);
nodes(4,:)=nodes(3,:)+2*ones(1,9);
nodes(5:8,:)=nodes(1:4,:)+18*ones(4,9);

% nodes=[1 3 13 11 2 8 12 6 7; 3 5 15 13 4 10 14 8 9];

% numeração dos graus de liberdade globais dos nós globais
igdl=0;
for i=1:nnode
    for j=1:ndof
        igdl=igdl+1;
        gdl(i,j)=igdl;
    end
end

%
% propriedades dos elementos
for iel=1:nelem
    Young(iel)=200e9; % especifica modulo de elasticidade igual para todos os elementso
    nu(iel)=0.3;
    tk(iel)=1e-3; % espessura
end
%
% Carregamento pontual nos nos
P(1:sdof)=0;
P(17)=1/6*0.25*1e5;
P(35)=2/3*0.25*1e5;
P(53)=2*1/6*0.25*1e5;
P(71)=P(35);
P(89)=P(17);
 P=P'; % transposicao para vector coluna
%
% Condicoes de fronteira de deslocamento
 % bcdof(1)=1; % graus de liberdade com restricao aplicada
 % bcval(1)=0; % valor da restricao aplicada
% bcdof=[1 11 12 21];
% bcval=[0 0 0 0];
 bcdof=[1 19 37 38 55 73];
 bcval=[0 0 0 0 0 0];

%
% inicializacao a zeros das matrizes e vectores
%
ff=zeros(sdof,1); % vector de forças global
kk=zeros(sdof,sdof); % matriz de rigidez global
index=zeros(nnel*ndof,1); % vector de indexacao dos graus de liberdade do elemento (para assemblegem)
%
% calculo das matrizes de rigidez e vectores de forcas dos elementos e respectiva assemblagem
for iel=1:nelem
  n=nodes(iel,1:nnel); % extraccao da numeracao global de nos para cada elemento
  xe=gcoord(n,1); % extraccao das coordenadas de cada no do elemento
  ye=gcoord(n,2);
  k=stif_Q9(Young(iel),nu(iel),tk(iel),xe,ye); % cálculo da matriz de rigidez do elemento
  f=zeros(18,1); % as forças distribuidas vão ser aplicadas nos nós (forças equivalentes nodais)
  index=eldof(iel,nnel,nodes,gdl);
  [kk,ff]=assemb(kk,ff,k,f,index);
end

% imposicao de condicoes de fronteira
[kk,ff]=cf(kk,ff,bcdof,bcval);

% imposicao de cargas pontuais
ff=ff+P;

% solucao do sistema de equacoes
u=kk\ff;


% representação da deformada
UX = u(1:2:2*nnode);
UY = u(2:2:2*nnode);
scaleFactor = 100;
figure
drawingField(gcoord+scaleFactor*[UX UY],nodes,'Q9',UX);%U XX
hold on
drawingMesh(gcoord+scaleFactor*[UX UY],nodes,'Q9','-');
drawingMesh(gcoord,nodes,'Q9','--');
colorbar
title('Displacement field u_x (on deformed shape)')
  
% cálculo das tensões (componentes no plano)
stress=zeros(nelem,4,3); % 3 in-plane componentes of stress per element, at the 4 Gauss points
for iel=1:nelem
   n=nodes(iel,1:nnel); % extraccao da numeracao global de nos para cada elemento
   xe=gcoord(n,1); % extraccao das coordenadas de cada no do elemento
   ye=gcoord(n,2);
   index=eldof(iel,nnel,nodes,gdl);
   ue=u(index); % deslocamentos do elemento
   stress(iel,:,:)=stress_Q9(Young(iel),nu(iel),tk(iel),xe,ye,ue); % tensões no plano
  % Extrapolation of the stress from Gauss points to Q9 nodes
   T=[ 1+0.5*sqrt(3), -0.5, 1-0.5*sqrt(3), -0.5;...
       -0.5, 1+0.5*sqrt(3), -0.5, 1-0.5*sqrt(3);...
       1-0.5*sqrt(3), -0.5, 1+0.5*sqrt(3), -0.5;...
       -0.5, 1-0.5*sqrt(3), -0.5, 1+0.5*sqrt(3);...
       (1+sqrt(3))/4, (1+sqrt(3))/4, (1-sqrt(3))/4, (1-sqrt(3))/4;...
       (1-sqrt(3))/4, (1+sqrt(3))/4, (1+sqrt(3))/4, (1-sqrt(3))/4;...
       (1-sqrt(3))/4, (1-sqrt(3))/4, (1+sqrt(3))/4, (1+sqrt(3))/4;...
       (1+sqrt(3))/4, (1-sqrt(3))/4, (1-sqrt(3))/4, (1+sqrt(3))/4;...
       0.25, 0.25, 0.25, 0.25];
   stress_nodes(iel,1:9,1)=T*stress(iel,1:4,1)';
   stress_nodes(iel,1:9,2)=T*stress(iel,1:4,2)';
   stress_nodes(iel,1:9,3)=T*stress(iel,1:4,3)';
end

% stress averaging at nodes
 stressAvg = zeros(nnode,3);
 for i = 1:3
     currentStress = stress_nodes(:,:,i);
     for n = 1:nnode
         idx = find(n==nodes);
         stressAvg(n,i) = sum(currentStress(idx))/length(currentStress(idx));
     end
 end
 
 % surface representation
 figure; hold on
 for k = 1:size(nodes,1)
     patch(gcoord(nodes(k,1:4),1), gcoord(nodes(k,1:4),2),...
     gcoord(nodes(k,1:4),1)*0, stressAvg(nodes(k,1:4),2))
 end
 axis equal; axis off
 colorbar
 title('Averaged nodal stress field \sigma_{xx}')

