flight(ankara,istanbul,2).
flight(istanbul,ankara,2).
flight(ankara,izmir,6).
flight(izmir,ankara,6).
flight(ankara,diyarbakır,8).
flight(diyarbakır,ankara,8).
flight(trabzon ,ankara,6).
flight(ankara,trabzon ,6).
flight(ankara,kars,3).
flight(kars,ankara,3).
flight(kars,gaziantep,3).
flight(gaziantep,kars,3).
flight(antalya,diyarbakır,5).
flight(diyarbakır,antalya,5).
flight(antalya,izmir,1).
flight(izmir,antalya,1).
flight(istanbul,izmir,3).
flight(izmir,istanbul,3).
flight(antalya,erzurum,2).
flight(erzurum,antalya,2).
flight(edirne,erzurum,5).
flight(erzurum,edirne,5).
flight(istanbul,trabzon,3).
flight(trabzon,istanbul,3).

route(X,Y,C) :- flight(X,Y,C).  % rule that checks a flight between given X, Y cities and C cost.
route(X,Y,C) :- cost(X,Y,C, []). % rule that calculates alternative paths and their cost with the cost rule.
cost(X,Y,C, _) :- flight(X,Y,C). % cost rule that finds direct route 
cost(X,Y,C,L) :-   %recursive cost calculater.
                  ( not(X=Y),not(member(X,L)) -> %if city is not a member of list and X not equal Y(target city is not found yet)
    				  flight(X,S,C1), %and there is a flight between X and another city destination S 				
					  cost(S,Y,C2,[X|L]), % call the cost rule to find another alternative also add X city to list to avoid conflicts.
    				  C is C1 + C2 ).%add costs to singleton C


