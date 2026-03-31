!set slib_header_coxhyp=\
\\ Action du groupe de Moebius etendu\
\\ Homographie ou antihomographie selon que g[3] vaut 0 ou 1.\
mob(g,z)=if(g[3],z=conj(z));(g[1]*z+g[2])/(conj(g[2])*z+conj(g[1]));\
\\ Produit et inverse dans le groupe de Moebius etendu\
mobx(g)=[g[1],g[2];conj(g[2]),conj(g[1])];\
mob_mul(g1,g2)=my(m=mobx(g1)*mobx(if(g1[3],conj(g2),g2)));[m[1,1],m[1,2],g1[3]!=g2[3]];\
mob_inv(g)=if(g[3],[g[1],-conj(g[2]),1],[conj(g[1]),-g[2],0]);\
\
hyp3(p,q,r,eps,depl)={\
  my(m=[1,p,q;p,1,r;q,r,1],nf0,nf1,nf2,f1,f2,nbs,snb,\
  ff1,s,t,u,g,gg,ggg,g1,x,y,z,res1,res2,ses1,r2,l,\
  ep=exp(I*(Pi/p)),\
  eq=exp(I*(Pi/q)),\
  er=exp(I*(Pi/r)),\
  a=0,\
  b=sqrt((cos(Pi/r)+cos(Pi/p+Pi/q))/(cos(Pi/r)+cos(Pi/p-Pi/q))),\
  c=ep*sqrt((cos(Pi/q)+cos(Pi/p+Pi/r))/(cos(Pi/q)+cos(Pi/p-Pi/r))),\
  mm=(b*c*conj(b-c)+c-b)/(conj(b)*c-conj(c)*b));\
  my(N=20); if(eps<1,\
    r2=(1-eps)^2;l=N*round(4*r2/(1-r2)/(1-1/p-1/q-1/r)),\
    l=eps; eps=4*N/(l*(1-1/p-1/q-1/r)+4*N));\
  my(cd0=vector(l), \\ pour chaque f, les numeros des 3 aretes du bord de la chambre f\
  ce0=vector(l), \\ et l'element g du groupe qui envoie la chambre 1 sur la chambre f\
  cd1=vector(2*l+1),\\ pour chaque a, les numeros des extremites de a\
  ce1=vector(2*l+1),\\ et le numero de la premiere chambre qu'elle borde\
  cd2=vector(l+2),\\ pour chaque s, le nombre d'aretes manquantes,\
  ce2=vector(l+2),\\ les deux aretes qui bordent le secteur restant\
  cf2=vector(l+2),\\ coordonnees du sommet\
  cg2=vector(l+2) \\ le sommet est dans la zone centrale\
  );\
\\ Les trois reflexions qui engendrent W\
  g=[[1,0,1],[ep,0,1],[I*mm,-I,1]];\
  if(depl,\
    a=mob(depl,a); b=mob(depl,b); c=mob(depl,c);\
    g=vector(3,i,mob_mul(depl,mob_mul(g[i],mob_inv(depl)))),\
    depl=[1,0,0]);\
\
  \\ Creation de la premiere chambre et de son squelette\
  cd0[nf0=1]=vector(3,s,s);\
  ce0[nf0]=[1,0,0]; \\ Identite\
  for (s = 1, 3,\
    cd1[nf1+=1] = vector(4, t, if(t>3,s,-1));\
    ce1[nf1]=1;\
    for (t=1, s-1,\
      cd2[nf2+=1] = 2*m[s,t]-2;\
      ce2[nf2] = [s,t];\
      snb=6-s-t;\
      cf2[nf2]=if(snb==1,c,if(snb==2,b,a));\
      cg2[nf2]=(sqrt(norm(cf2[nf2]))+eps)<1;\
      cd1[t][s] = cd1[s][t] = nf2));\
  while(f1<nf1 && nf0<l, f1+=1; v1=cd1[f1];\
   if((s=v1[4]) && (cg2[v1[s%3+1]] || cg2[v1[5-s-s%3]]), \\ arete a traiter\
\\ element du groupe associe au triangle precedent\
   gg=ce0[ce1[f1]];\
\\ Nouveau triangle et ses aretes, manquantes ou pas\
   ce0[nf0+=1]=ggg=mob_mul(gg,g[s]);\
  w0=vector(3); w0[s]=f1; new=vector(3,t,if(t!=s,cd2[v1[t]]));\
    for(t=1, 3, if(t!=s, f2=v1[t]; if(new[t],\
    w1=vector(4); w1[4]=t; w1[s]=f2; w1[t]=-1;\
    cd1[nf1+=1]=w1; ce1[nf1]=nf0; cd2[f2]=new[t]-1; ce2[f2]=w0[t]=nf1,\
    g1=w0[t]=ce2[f2]; cd1[g1][4]=0)));\
\\ Mise a jour (et creation si necessaire) des sommets non encore traites\
    for(t=1,3,if(new[t], g1=w0[t];\
      for(u=1,3,if((u!=t) && (u!=s),\
        if(new[u],\
      if(w0[u]<g1, cd2[nf2+=1]=2*m[t,u]-2; ce2[nf2]=g1;\
      snb=6-t-u;\
      cf2[nf2]=mob(ggg,if(snb==1,c,if(snb==2,b,a)));\
      cg2[nf2]=(sqrt(norm(cf2[nf2]))+eps)<1;\
      cd1[w0[u]][t]=cd1[g1][u]=nf2),\
      cd1[g1][u]=f2=cd1[w0[u]][t]; cd2[f2]-=1; ce2[f2]=g1)))));\
      cd0[nf0]=w0;\
      )\
  );\
  [matrix(nf2,2,i,j,if(j==1,real(cf2[i]),imag(cf2[i]))),\
   matrix(nf0,4,i,j,if(j<4,cd1[cd0[i][j%3+1]][5-j-j%3],ce0[i][3]))]\
}
