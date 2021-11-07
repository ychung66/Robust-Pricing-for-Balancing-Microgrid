function dx = mdynmaic(A,x,b,tau,prc,B,w)
%% Dynamic of microgrid with power system market, see Eq(7)
dx = A*x + b + tau*prc + B*w;
