

file_id=fopen('../Data/position/gmm2d.asc','r');
 
donnee = load("../Data/position/gmm2d.asc");
X = donnee(:,1);
Y = donnee(:,2);
NB_REGION = 4;
TAILLE_DONNEE = size(donnee,1);
DIMENSION = size(donnee,2);

i =1;
K = zeros(NB_REGION,DIMENSION);
new_K = zeros(NB_REGION,DIMENSION);
toto = zeros(NB_REGION+2,DIMENSION);


 classe_k = zeros(NB_REGION+2,1);
classe_k(1:NB_REGION) = 5;

% on attribue au 2 dernier point les limites d'afichage pour visionner les points 
%des region de facon correcte
toto(NB_REGION+1,1) = -5;
toto(NB_REGION+1,2) = -10;
toto(NB_REGION+2,1) = 20;
toto(NB_REGION+2,2) = 25;

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
taille = size(donnee,1);
j=0;

classe = zeros(TAILLE_DONNEE,1);
distmin = 0;
while(K != new_K)

  while(i != taille) 
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
   sum_for_reg_x = zeros(NB_REGION,1);
   sum_for_reg_y = zeros(NB_REGION,1);

  while(i != taille) 
  nb_region(classe(i)) = nb_region(classe(i)) +1;
  sum_for_number(classe(i)) = sum_for_number(classe(i))+1;
  sum_for_reg_x(classe(i)) = sum_for_reg_x(classe(i))+ donnee(i,1);
  sum_for_reg_y(classe(i)) = sum_for_reg_y(classe(i))+ donnee(i,2);

  i = i+1;
endwhile;

toto(1:NB_REGION,:) = K(:,:);

 figure(2);
 scatter(X,Y,1,classe)
hold on;
scatter(toto(:,1),toto(:,2),30,classe_k,"filled");
hold off;
title('module de mon image');
w = waitforbuttonpress;

i=1;
new_K(:,:) = K(:,:);

while(i<=NB_REGION)
K(i,1) = sum_for_reg_x(i) / sum_for_number(i);
K(i,2) = sum_for_reg_y(i) / sum_for_number(i);

i++;
endwhile
toto_region = nb_region;

iteration ++
endwhile

 
 


% prendre tout les points d'une regions pour en faire le barycentre puis refait 
% la boucle avec les nouveaux centres de regions
