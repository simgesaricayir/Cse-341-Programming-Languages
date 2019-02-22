:- dynamic student/3.
:- dynamic course/7.
:- dynamic room/5.

%Order of arguments : id of room, capacity of room, operations hours of room, special equipment(projector or smartboard),
% access for the handicapped students.
% Also it is a dynamic predicate to allow user to add new one.
room(z06,10,[8,9,10,11,12,13,14,15,16],projector,handicapped).
room(z11,10,[8,9,10,11,12,13,14,15,16],smartboard,handicapped).

%Order of arguments : id of course, id of instruction ,capacity of course, room id ,
% student ids that enrolled the lesson, special need of course(projector or smartboard). 
course(cse341,genc,10,[8,9,10,11],z06,[6,7,8,9],projector).
course(cse343,turker,6,[8,9,10,11],z11,[3,4,5,6,7,8],smartboard).
course(cse331,bayrakci,5,[13,14,15],z06,[1,2,3,4],projector).
course(cse321,gozupek,10,[14,15,16],z11,[1,2,3,4,5,6,7,8,9,10],smartboard).

%Occupancy predicate is wrote for holding room’s occupancy information.
% Order of arguments : id of room , course id  that holds the room , list of hours for course.
occupancy(z06,cse341,[8,9,10,11]).
occupancy(z06,cse331,[13,14,15]).
occupancy(z11,cse343,[8,9,10,11]).
occupancy(z11,cse321,[14,15,16]).
%Order of arguments :  instructor id , course ids that instructor taught, preference for rooms(projector or smartboard).
instructor(genc,[cse341],projector).
instructor(turker,[cse343],smartboard).
instructor(bayrakci,[cse331],_).
instructor(gozupek,[cse321],smartboard).

%Order of arguments : id of student, courses that student attended, handicapped information.
student(1,[cse341,cse343,cse331],_).
student(2,[cse341,cse343],_).
student(3,[cse341,cse331],_).
student(4,[cse341],_).
student(5,[cse343,cse331],_).
student(6,[cse341,cse343,cse331],handicapped).
student(7,[cse341,cse343],_).
student(8,[cse341,cse331],handicapped).
student(9,[cse341],_).
student(10,[cse341,cse321],_).
student(11,[cse341,cse321],_).
student(12,[cse343,cse321],_).
student(13,[cse343,cse321],_).
student(14,[cse343,cse321],_).
student(15,[cse343,cse321],handicapped).

%add rules which add the predicate last.
addstudent(Id,Courses,H):- assertz(student(Id,Courses,H)).
addcourse(Id,Instr,Capacity,Hours,RoomId,StudentIds,Equipment,H):-assertz(course(Id,Instr,Capacity,Hours,RoomId,StudentIds,Equipment,H)).
addroom(Id,Capacity,Hours,Equipment,H):-assertz(roomId,Capacity,Hours,Equipment,H)).

% : It checks given course’s hours with checking occupany predicate.
%  If there is a conflict of course hours result is true, otherwise false.
%Usage : conflicts(cse331,cse321) -> result is true or false
conflicts(CourseId1,CourseId2) :- occupancy(_,CourseId1,Hours1),
                                  occupancy(_,CourseId2,Hours2),
                                  ( match(Hours1,Hours2) ->  
                                    true
                                  ; match(Hours1,Hours2)).  


%Firstly, student and course is found with their id’s.
% Course’s capacity is checked with attended student list’s length.
%If there is capacity for the student and student’s courses has no conflict with the new course that student wants to enroll,
% also if student is handicapped, course’s room is checked for suitable for it.
% All these conditions are provided student can enroll. 
% Usages :    
% enrollStudent(1,cse321) -> result is true or false
%enrollStudent(5,CourseId) -> if course found it lists course id’s(if there is more than one it requires write ';' on the console)                
enrollStudent(StudentId,CourseId) :- student(StudentId,ListCourses,HANDC),
                                     course(CourseId,_,CAPACITY,_,RoomId,LIST,_),
                    \+compareConflictsCourse(CourseId,ListCourses),
                                     (   enoughCapacity(LIST, CAPACITY)->  
                                
                                    (  HANDC = 'handicapped' ->  
                                        room(RoomId,_,_,_,HANDC)
                                      ;   room(RoomId,_,_,_,_)
                                    )) .

%If only course id is given to rule, it returns a roomid for that course.
%First It takes instruction Id from the course’s predicate declaration with help of course id.
%Then instruction’s equipment predicate is searched in the rooms.
%Then all students that attend to course are searched for checking handicapped student is attended or not in the course.
%Also course’s capacity and room’s capacity is compared.
%Then suitable room for the course is found with equipment and handicaped and capacity information.
% Usages : assign(RoomId,cse331) ---> it gives room id or ids if there is a suitable room.
% If more than one room id is found you should use ';' to continue on the console.
%     assign(RoomId,CourseId) ----> it gives which room is suitable for which course     
% If more than one result is found you should use ';' to continue to see all on the console.      
assign(RoomId,COURSEID) :- course(COURSEID,Instr,CapacityC,_,_,StudentsList,_),
                            instructor(Instr,_,Equipment),
                           (   handicappedStudent(StudentsList)  ->   
                               (     
                                   Equipment= nothing -> 
                                   room(RoomId,CapacityR,_,_,handicapped)
                                   ; room(RoomId,CapacityR,_,Equipment,handicapped)
                               )
                              ;(   Equipment= nothing -> 
                                   room(RoomId,CapacityR,_,_,_)
                                   ; room(RoomId,CapacityR,_,Equipment,_)
                               )
                             
                           ),enoughCapacityRoom(CapacityR,CapacityC).     


%capacity checks
lengthCapacity(X,Y) :- length(X, Y).%method that takes a list X is list.Y is length of it.
enoughCapacity(X,Y) :- lengthCapacity(X, Z), Z < Y. % check given capacity is smaller than other.
enoughCapacityRoom(X,Y) :- X >= Y. %check room's capacity is suitable for course's capacity.

%rules which recursive list search
match([Head|_], List2):-
        ( memberchk(Head,List2)  ->
        true
        ; match(Head,List2)) .  
match([_|Tail],List2):-
       match(Tail,List2). 

% rule that checks the given course's conflict with the given course lists.
compareConflictsCourse(CourseId,[Head|Tail]) :- (   conflicts(CourseId,Head) ->
                                                  true
                                                ;  compareConflictsCourse(CourseId,Tail)).

%recursive rule for checking the given list which holds student ids to there is at least one
% handicapped student in the course or not.
handicappedStudent([L1Head|L1Tail]) :- student(L1Head,_,HANDC),
                                        (   HANDC = 'handicapped' ->  
                                            true
                                        ;handicappedStudent(L1Tail)
                                        ). 

                                  




                       
                          
                           



                           

                            

                                    
                                    
 