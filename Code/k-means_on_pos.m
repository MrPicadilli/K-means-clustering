

file_id=fopen('../Data/position/gmm2d.asc','r');
file_id3=fopen('../Data/position/gmm2d.asc','r');

donnee = load("../Data/position/gmm2d.asc");
%donnee = load("gmm3d.asc");
% a changer en fonction de la dimension
X = donnee(:,1);
Y = donnee(:,2);
%Z = donnee(:,3);

NB_REGION = 4;
TAILLE_DONNEE = size(donnee,1);
DIMENSION = size(donnee,2);



C =zeros(NB_REGION,DIMENSION);
i =1;
K = zeros(NB_REGION,DIMENSION);
new_K = zeros(NB_REGION,DIMENSION);
region = zeros(NB_REGION+2,DIMENSION);


classe_k = zeros(NB_REGION+2,1);
classe_k(1:NB_REGION) = NB_REGION +1;

% on attribue au 2 dernier point les limites d'afichage pour visionner les points 
%des region de facon correcte
region(NB_REGION+1,1) = -5;
region(NB_REGION+1,2) = -10;
region(NB_REGION+2,1) = 20;
region(NB_REGION+2,2) = 25;

% on remplit les regions par des points aleatoire trouvé dans les données
aleatoire = randperm(TAILLE_DONNEE);

n = 1;
while( n <= NB_REGION)
  K(n,:) = donnee(aleatoire(n),:);
  n++;
endwhile;
iteration = 0;

  i=0;
  mindist = 10000;

indice =  mindist;

%indice_closest(x,K)
j=0;

classe = zeros(TAILLE_DONNEE,1);
distmin = 0;



while(sum(C(:)) != NB_REGION * DIMENSION)
%j'attribue a chaque points un identiffiant qui représente son appartenance a une region
  while(i != TAILLE_DONNEE) 
    i = i+1;
    mindist = 100000;
    j = 0;
    dist=0;
    distmin=1000;
    while(j != NB_REGION) 
      j = j+1;
      d = 1;
      %dist =  sqrt((K(j,1) - donnee(i,1)) * (K(j,1) - donnee(i,1)) + (K(j,2) - donnee(i,2)) * (K(j,2) - donnee(i,2)));
      dist = 0;
      while(d <= size(K,2))
        dist =  dist +  sqrt((K(j,d) - donnee(i,d)) * (K(j,d) - donnee(i,d)));
        d ++;
      endwhile;
      if dist < distmin
        mindist = j;
        distmin = dist;
      endif
    endwhile;
    
    classe(i) = mindist;  
  endwhile;
  
  
   nb_region = zeros(NB_REGION,1);
   i =1;
   sum_for_number = zeros(NB_REGION,1);
   sum_for_reg = zeros(NB_REGION,DIMENSION);


   sum_for_reg_x = zeros(NB_REGION,1);
   sum_for_reg_y = zeros(NB_REGION,1);
   %je remplie un tableau de la somme des coordonnées de mes points selon leur regions d'appartenance
  while(i != TAILLE_DONNEE) 
    nb_region(classe(i)) = nb_region(classe(i)) +1;
    sum_for_number(classe(i)) = sum_for_number(classe(i))+1;
    c = 1;
    while(c <= DIMENSION)
    sum_for_reg(classe(i),c) = sum_for_reg(classe(i),c) + donnee(i,c);
    c++;
    endwhile;
    i = i+1;
  endwhile;
  
region(1:NB_REGION,:) = K(:,:);
%{
figure(2);
scatter(X,Y,1,classe)
hold on;
scatter(region(:,1),region(:,2),30,classe_k,"filled");
hold off;
title('application de algo K-means sur 10 000 points');
w = waitforbuttonpress;
%}


i=1;
%je sauvegarde les anciens centre des regions
new_K(:,:) = K(:,:);

%je calcule les nouveau centre des regions
  while(i<=NB_REGION)
    t = 1;
    while(t <= DIMENSION)
      K(i,t) = sum_for_reg(i,t) / sum_for_number(i);
      t++;
    endwhile;
    i++;
  endwhile;


toto_region = nb_region;
C =  uint8(new_K) == uint8(K)
%C =  new_K == K

test = K(:) == new_K(:);

iteration ++
endwhile
%3D
 %{
figure(1);
scatter3(X,Y,Z,1,classe)
hold on;
scatter3(region(:,1),region(:,2),region(:,3),30,classe_k,"filled");
hold off;
title('application de algo K-means sur 10 000 points');
%}

%2D

figure(1);
scatter(X,Y,1,classe)
hold on;
scatter(region(:,1),region(:,2),30,classe_k,"filled");
hold off;
title('application de algo K-means sur 10 000 points');
%}

