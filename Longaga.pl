

menu :-
    write('Longaga'), nl,
    write('Select an option'), nl,
    write('1. New Game'), nl,
    write('2. Load Game'), nl,
    read(Input),
    makeChoice(Input).


getTournamentScore(TournScore) :-
    write('Enter the tournament score'), nl,
    read(TournScore).


% =========================
% CHOICES
% =========================

shuffle([], []).
shuffle(List, [R|Rest]) :-
    random_member(R, List),
    delete(List, R, NewList),
    shuffle(NewList, Rest).

deal_n(0, Deck, [], Deck).

deal_n(N, [H|T], [H|Hand], Rest) :-
    N > 0,
    N1 is N - 1,
    %with each call, H gets removed from T and put into Hand
    %how is rest being decremented as well as what is in the stock
    %where is the code to show N adding a number in H
    deal_n(N1, T, Hand, Rest).



tiles([
    '0-0','0-1','0-2','0-3','0-4','0-5','0-6',
    '1-1','1-2','1-3','1-4','1-5','1-6',
    '2-2','2-3','2-4','2-5','2-6',
    '3-3','3-4','3-5','3-6',
    '4-4','4-5','4-6',
    '5-5','5-6',
    '6-6'
    ]).

engines(['6-6', '5-5', '4-4', '3-3', '2-2', '1-1', '0-0']).


findEngine(Hand, Engine) :-
    member(Engine, Hand).


drawTile(OldHand, [BH|Boneyard], NewHand, Boneyard1) :-
    append(OldHand, [BH], NewHand),
    Boneyard1 = Boneyard.





obtainEngine(HumanHand, ComputerHand, Boneyard, _Layout, RequiredEngine, HumanHand1, ComputerHand1, Boneyard1, CurrentPlayer, NextPlayer) :-
    (   findEngine(HumanHand, RequiredEngine)
    ->  write('Engine already in human hand'), nl,
        HumanHand1 = HumanHand,
        ComputerHand1 = ComputerHand,
        Boneyard1 = Boneyard,
        CurrentPlayer = 0,
        NextPlayer = 1
    ;   % THIS PARENTHESIS IS CRITICAL
        (   findEngine(ComputerHand, RequiredEngine)
        ->  write('Engine already in computer hand'), nl,
            HumanHand1 = HumanHand,
            ComputerHand1 = ComputerHand,
            Boneyard1 = Boneyard,
            CurrentPlayer = 1,
            NextPlayer = 0
        ;   % THIS IS THE FINAL ELSE
            write('No engine found. Starting draws...'), nl,
            StartCP = 0,
            StartNP = 1,
            draw_loop(StartCP, StartNP, HumanHand, ComputerHand, Boneyard,
                      RequiredEngine, HumanHand1, ComputerHand1, Boneyard1, CurrentPlayer, NextPlayer)
        )
    ).



draw_loop(_, _, _, H, C, [], _, H, C, [], _, _) :-
    write('Boneyard empty. No engine found.'), nl, !.

draw_loop(0, 1, HumanHand, ComputerHand, Boneyard, RequiredEngine, HumanHand1, ComputerHand1, Boneyard1, NewCurrent, NewNext) :-
    %write('STATE IN HUMAN: '), write([HumanHand, ComputerHand, Boneyard]), nl,
    %format('REQUIRED ENGINE HUMAN: ' ), write(RequiredEngine), nl,
    %format('BH HUMAN: ' ), write(BH), nl,

    drawTile(HumanHand, Boneyard, NewHumanHand, NewBoneyard),
    write('Human draws'), write(NewHumanHand),nl,

    %if engine is found initialize, otherwise have computer draw
    ( findEngine(NewHumanHand, RequiredEngine)
    -> HumanHand1 = NewHumanHand,
       ComputerHand1 = ComputerHand,
       Boneyard1 = NewBoneyard,
       NewCurrent = 0, % Human is current
       NewNext = 1,    % Computer is next
       write('Human got the engine!'), nl;
       
    draw_loop(1, 0, NewHumanHand, ComputerHand, NewBoneyard, RequiredEngine, HumanHand1, ComputerHand1, Boneyard1, NewCurrent, NewNext) 
    ).

draw_loop(1, 0, HumanHand, ComputerHand, Boneyard, RequiredEngine, HumanHand1, ComputerHand1, Boneyard1, NewCurrent, NewNext) :-
    %write('STATE IN COMPUTER: '), write([HumanHand, ComputerHand, Boneyard]), nl,
    %format('REQUIRED ENGINE COMPUTER: ' ), write(RequiredEngine), nl,
    %format('BH COMPUTER: ' ), write(BH), nl,


    drawTile(ComputerHand, Boneyard, NewComputerHand, NewBoneyard),
    write('Computer draws'), write(NewComputerHand), nl,

    ( findEngine(NewComputerHand, RequiredEngine)
    -> HumanHand1 = HumanHand,
       ComputerHand1 = NewComputerHand,
       Boneyard1 = NewBoneyard,
       NewCurrent = 1, % Human is current
       NewNext = 0,    % Computer is next
       write('Computer got the engine!'), nl;


     draw_loop(0, 1, HumanHand, NewComputerHand, NewBoneyard, RequiredEngine, HumanHand1, ComputerHand1, Boneyard1, NewCurrent, NewNext) 
    ).


removeTile(0, Tile, HumanHand, ComputerHand, NewHumanHand, ComputerHand) :-
    removeTileFromHand(Tile, HumanHand, NewHumanHand).

removeTile(1, Tile, HumanHand, ComputerHand, HumanHand, NewComputerHand) :-

    removeTileFromHand(Tile, ComputerHand, NewComputerHand).

removeTileFromHand(Tile, [Tile|HandT], HandT).
removeTileFromHand(Tile, [HandH|Hand], [HandH|NewHand]) :-
    removeTileFromHand(Tile, Hand, NewHand).


%do these need to be declared
newGame(HumanHand, ComputerHand, Layout, Boneyard, FinalHHand, FinalCHand, FinalLayout, FinalBoneyard, CurrentPlayer, NextPlayer) :-
    write('Starting new game...'), nl,

    %Put tiles in local variable
    tiles(Tiles),

    %shuffle the tiles
    shuffle(Tiles, ShuffledTiles),

    %deal 8 tiles in each hand before starting the game
    deal_n(8, ShuffledTiles, HumanHand, RemainingStock),
    deal_n(8, RemainingStock, ComputerHand, RemainingStock1),

    Engine = '6-6',
    Layout = [],
    Boneyard = RemainingStock1,

    obtainEngine(HumanHand, ComputerHand, Boneyard, Layout, Engine, HumanHand1, ComputerHand1, FinalBoneyard, CurrentPlayer, NextPlayer),   

    addTileToLayout(Engine, 'l', Layout, FinalLayout),

    %CURRENTPLAYER IS NOT MODIFIED IN THIS FUNCTION
    removeTile(CurrentPlayer, Engine, HumanHand1, ComputerHand1, FinalHHand, FinalCHand).





%both plays have passed
gameLoop(_, _, HumanPassed, ComputerPassed, _, _, _, _, _, _, _, _, _):-
    HumanPassed == true, 
    ComputerPassed == true,
    write('Both players passed. It is a draw.'), nl.
gameLoop(_, _, _, _, _, _, _, [], _, _, _, _, _):-
    write('Human has no more tiles. Human wins the round!'), nl.
gameLoop(_, _, _, _, _, _, _, _, [], _, _, _, _):-
    write('Computer has no more tiles. Computer wins the round!'), nl.
gameLoop(Layout, Boneyard, CurrentPlayer, NextPlayer,
 HumanPassed, ComputerPassed, HumanScore, ComputerScore, 
 TournScore, HumanHand, ComputerHand):-

    return_left(Layout, LeftEnd),
    return_right(Layout, RightEnd),
    format('LEFT AND RIGHT: '),

    displayUI(TournScore, HumanHand, ComputerHand, Layout, Boneyard),
    format('DISPLAYUI: '),

    %CurrentPlayer = 0,
    %NextPlayer = 1,
    turnFunc(CurrentPlayer, NextPlayer, HumanPassed, ComputerPassed,
         HumanHand, ComputerHand, Layout, Boneyard,
         NewHumanHand, NewComputerHand, NewLayout, NewBoneyard,
         LeftEnd, RightEnd, NewCurrent, NewNext, NewHumanPassed, NewComputerPassed),


    %displayUI(TournScore, NewHumanHand, NewComputerHand, NewLayout, NewBoneyard),
    %format('DISPLAYUI: ').

    format("NewCurrent: "), write(NewCurrent), nl,
    format("NewNext: "), write(NewNext), nl,

    format("NewHumanPassed: "), write(NewHumanPassed), nl,
    format("NewComputerPassed: "), write(NewComputerPassed), nl,

    format("HumanScore: "), write(HumanScore), nl,
    format("ComputerScore: "), write(ComputerScore), nl,

    format("TournScore: "), write(TournScore), nl,
    format("NewHumanHand: "), write(NewHumanHand), nl,

    
    format("NewComputerHand: "), write(NewComputerHand), nl,
    format("NewLayout: "), write(NewLayout), nl,
    format("NewBoneyard: "), write(NewBoneyard), nl,

    gameLoop(NewLayout, NewBoneyard, NewCurrent, NewNext,
    NewHumanPassed, NewComputerPassed, HumanScore, ComputerScore, 
    TournScore, NewHumanHand, NewComputerHand).




turnFunc( 0, _, HumanPassed, ComputerPassed, HumanHand, ComputerHand, Layout, Boneyard,
         NewHumanHand, NewComputerHand, NewLayout, NewBoneyard, LeftEnd, RightEnd, 
         NewCurrent, NewNext, NewHumanPassed, NewComputerPassed) :-


    %reset pass at each turn
    NewHumanPassed = false,

    write('Select an option:'), nl,
    write('1. Play 2. Draw 3. Pass 4. Help 5. Save'), nl,
    read(SelectedOption),
    write('Human turn'), nl,
    takeTurn(SelectedOption, HumanHand, ComputerHand, Boneyard, Layout, HumanPassed, ComputerPassed, LeftEnd, RightEnd, NewHumanHand, NewComputerHand, NewLayout, NewBoneyard, NewHumanPassed, NewComputerPassed),

    write('INITIALIZE>>>>>>'), nl,
    %NewBoneyard = Boneyard,
    %NewComputerHand = ComputerHand,
    %NewHumanPassed = HumanPassed,
    %NewComputerPassed = ComputerPassed,

    write('2>>>>>>'), nl,
    write('3>>>>>>'), nl,
    write('4>>>>>>'), nl,
    NewCurrent = 1,
    write('5>>>>>>'), nl,
    NewNext = 0,
    write('6>>>>>>'), nl.



turnFunc(1, _, HumanPassed, ComputerPassed, HumanHand, ComputerHand, Layout, Boneyard,
         NewHumanHand, NewComputerHand, NewLayout, NewBoneyard, LeftEnd, RightEnd, NewCurrent, NewNext, NewHumanPassed, NewComputerPassed) :-


    %reset pass at each turn
    NewComputerPassed = false,

    write('AI is thinking...'), nl,

    % 1. Find options - Use the variables from the header!
    comp_playable_tiles(ComputerHand, LeftEnd, RightEnd, HumanPassed, Options),

    % 2. If no options, the AI MUST draw or pass (You are missing this logic!)
    ( Options == [] -> 

        ( Boneyard == [] -> 
            write('I have no playable tiles and the boneyard is empty. I will pass.'),
            NewComputerPassed = true

            ;
            write('I have no playable tiles. Proceeding with drawing...'),
            write('still in process')
        )

    ;   
        % 3. Find the best move using '1' as the player ID for Computer
        find_best_move(Options, ComputerHand, LeftEnd, RightEnd, 1, _BestTile, BestIndex, BestSide),
        applyMove(ComputerHand, BestIndex, BestSide, Layout, NewComputerHand, NewLayout),
        
        NewHumanPassed = HumanPassed, 
        NewComputerPassed = ComputerPassed,
        NewHumanHand = HumanHand,
        NewBoneyard = Boneyard
    ),
    
    NewCurrent = 0,
    NewNext = 1.





find_best_move(Options, Hand, LeftEnd, RightEnd, Player, BestTile, Index, Side) :-
    setof([Score, Tile], % Store the original string 'Tile' here
          (
            member([Index, Side], Options),
            nth0(Index, Hand, Tile), % Grab the string '5-6'
            parse_tile(Tile, A, B),
            score_tile(A, B, LeftEnd, RightEnd, Player, Score)
          ), 
          ScoredList),
    last(ScoredList, [_BestScore, BestTile]). % Returns '5-6'

score_tile(A, B, _LeftEnd, _RightEnd, Player, Score) :-
    % 1. Calculate base weight (equivalent to tileWeight(a, b))
    tile_weight(A, B, Weight),
    
    % 2. Calculate double bonus
    double_bonus(A, B, Player, DoubleScore),
    
    % 3. Total Score
    Score is Weight + DoubleScore.

% --- Helper Predicates ---
% Rule 1: Only matches if A and B are the same
double_bonus(A, A, _, 10). 

% Rule 2: Only matches if A and B are NOT the same
double_bonus(A, B, _, 0) :- 
    A \= B.

% Mock tile_weight: sum of the two numbers (adjust based on your actual tileWeight logic)
tile_weight(A, B, Weight) :- 
    Weight is A + B.



return_left([First|_], LeftEnd) :-
    parse_tile(First, LeftEnd, _).

return_right([Tile], RightEnd) :-
    parse_tile(Tile, _, RightEnd).
return_right([_|Tail], RightEnd) :-
    return_right(Tail, RightEnd).



parse_tile(Tile, A, B) :-
    split_string(Tile, "-", "", [S1, S2]),
    number_string(A, S1),
    number_string(B, S2).



find_playable_tiles(Hand, LeftEnd, RightEnd, ComputerPassed, Options) :-

    format("Computer Passed?: "), write(ComputerPassed), nl,
    findall([Index, Side],
        (
            nth0(Index, Hand, Tile),
            parse_tile(Tile, A, B),
            (
                % LEFT SIDE: Standard matching
                (A =:= LeftEnd ; B =:= LeftEnd),
                Side = l
            ;
                % RIGHT SIDE: Must match AND (be a double OR computer passed)
                (A =:= RightEnd ; B =:= RightEnd), % First, it MUST match the board
                (ComputerPassed ; A == B),            % THEN, check the special conditions
                Side = r
            )
        ),
    Options).


comp_playable_tiles(Hand, LeftEnd, RightEnd, HumanPassed, Options) :-

    format("Human Passed?: "), write(HumanPassed), nl,

    findall([Index, Side],
        (
            nth0(Index, Hand, Tile),
            parse_tile(Tile, A, B),
            (
                % RIGHT SIDE: Standard matching
                (A =:= RightEnd ; B =:= RightEnd),
                Side = r
            ;
                % LEFT SIDE: Must match AND (be a double OR computer passed)
                (A =:= LeftEnd ; B =:= LeftEnd), % First, it MUST match the board
                (HumanPassed ; A == B),            % THEN, check the special conditions
                Side = l
            )
        ),
    Options).






turnLoop(HumanHand, Options, Layout, NewHumanHand, NewLayout) :-
    write('Enter a tile to play: '), nl,
    read(ChosenTile),
    findIndexByTile(HumanHand, ChosenTile, Index),
    write('Enter which side to play (L or R): '), nl,
    read(Side),

    format("INDEX: "), write(Index), nl,
    format("SIDE: "), write(Side), nl,

    %if it exists in the layout
    ( member([Index, Side], Options)
    -> applyMove(HumanHand, Index, Side, Layout, NewHumanHand, NewLayout),
        format('TURN LOOP LAYOUT: '), write(NewLayout), nl
    ;  write('Invalid move. Try again.'), nl,
       turnLoop(HumanHand, Options, Layout, NewHumanHand, NewLayout)
    ).




tileBehavior(ChosenTile, ChosenSide) :-
    write('Enter a tile to play:'), nl,
    read(ChosenTile),
    write('Enter which side to play (L or R): '), nl,
    read(ChosenSide).


findIndexByTile(Hand, Tile, Index) :-
    nth0(Index, Hand, Tile).


flipTile(ChosenTile, FlippedTile) :-
    string_chars(ChosenTile, Chars),        % Convert string to list of characters
    reverse(Chars, ReversedChars), % Use built-in reverse/2 on the list
    string_chars(FlippedTile, ReversedChars). % Convert list back to string


% Case 1: Playing on the LEFT side of the layout
determine_tile_orientation(Tile, l, Layout, FinalTile) :-
    return_left(Layout, LeftEnd),
    parse_tile(Tile, A, B),
    (   B =:= LeftEnd -> FinalTile = Tile             % Matches as-is
    ;   A =:= LeftEnd -> flipTile(Tile, FinalTile)    % Needs flipping
    ).

% Case 2: Playing on the RIGHT side of the layout
determine_tile_orientation(Tile, r, Layout, FinalTile) :-
    return_right(Layout, RightEnd),
    parse_tile(Tile, A, B),
    (   A =:= RightEnd -> FinalTile = Tile            % Matches as-is
    ;   B =:= RightEnd -> flipTile(Tile, FinalTile)   % Needs flipping
    ).

applyMove(HumanHand, Index, Side, Layout, NewHumanHand, NewLayout) :-
    write('Applying move...'), nl,

    nth0(Index, HumanHand, ChosenTile),

    format("Placed ~w on side ~w.~n", [ChosenTile, Side]),

    parse_tile(ChosenTile, A, B),

    (   A =:= B
    ->  write("Trying to get rid of doubles as soon as possible"), nl,
        write("Doubles placed left to disrupt opponent flow"), nl
    ;   TotalPipValue is A + B,
        format("The pips on tile ~w and ~w add up to ~w.~n",
            [A, B, TotalPipValue]),
        write("Continuing to hold tiles with lots of pips would soften the blow if I were to lose; the player gets less points"), nl
    ),

    determine_tile_orientation(ChosenTile, Side, Layout, FinalTile),

    addTileToLayout(FinalTile, Side, Layout, NewLayout),
    removeTileFromHand(ChosenTile, HumanHand, NewHumanHand),
    write('Move applied. New layout: '), nl,
    format('APPLY MOVE LAYOUT: '), write(NewLayout), nl.



takeTurn(1, HumanHand, ComputerHand, Boneyard, Layout, HumanPassed, ComputerPassed, LeftEnd, RightEnd, NewHumanHand, NewComputerHand, NewLayout, NewBoneyard, NewHumanPassed, NewComputerPassed) :-
    write('ENTERING FIND TILES'), nl,
    
    find_playable_tiles(HumanHand, LeftEnd, RightEnd, ComputerPassed, Options),
    write('Playable options: '), write(Options), nl,
    turnLoop(HumanHand, Options, Layout, NewHumanHand, NewLayout),
    NewBoneyard = Boneyard,
    NewComputerHand = ComputerHand,
    NewHumanPassed = HumanPassed,
    NewComputerPassed = ComputerPassed,
    format('takeTurn LAYOUT: '), write(NewLayout), nl.





takeTurn(2, HumanHand, ComputerHand, Boneyard, Layout, HumanPass, ComputerPass, LeftEnd, RightEnd, NewHumanHand, NewComputerHand, NewLayout, NewBoneyard, NewHumanPassed, NewComputerPassed) :-
    write('Draw tile'), nl,


    write('Human draws'), write(Boneyard), nl,
    drawTile(HumanHand, Boneyard, DrawHand, Boneyard1),
    nth0(0, DrawHand, DrawnTile),

    find_playable_tiles([DrawnTile], LeftEnd, RightEnd, ComputerPass, Options),
   (   Options == [] -> 
        % CASE 1: Still no moves
        write('Drawn tile unplayable. Passing turn.'), nl,
        NewHumanHand = DrawHand,
        NewComputerHand = ComputerHand,
        NewBoneyard = Boneyard1,
        NewLayout = Layout,
        NewHumanPassed = true,
        NewComputerPassed = ComputerPass
    ;   length(Options, 1) ->
        % CASE 2: Exactly one move possible (Auto-play)
        write('Drawn tile is playable! Auto-playing only option...'), nl,
        nth0(0, Options, [Index, Side]), % Get the index/side from the one option
        applyMove(DrawHand, Index, Side, Layout, NewHumanHand, NewLayout),
        NewComputerHand = ComputerHand,
        NewBoneyard = Boneyard1,
        NewHumanPassed = false,
        NewComputerPassed = ComputerPass
    ;   % CASE 3: More than one move (Manual play - for later)
        write('Drawn tile is playable! Multiple sides available.'), nl,
        write('OPTIONS:::'), write(Options), nl,
        % For now, just pass through so it doesnt crash
        NewHumanHand = DrawHand,
        NewComputerHand = ComputerHand,
        NewBoneyard = Boneyard1,
        NewLayout = Layout,
        NewHumanPassed = false,
        NewComputerPassed = ComputerPass
    ).



takeTurn(3, HumanHand, ComputerHand, Boneyard, Layout, HumanPass, ComputerPass, LeftEnd, RightEnd, NewHumanHand, NewComputerHand, NewLayout, NewBoneyard, NewHumanPassed, NewComputerPassed) :-
    NewHumanHand = HumanHand,
    NewComputerHand = ComputerHand,
    NewBoneyard = Boneyard,
    NewLayout = Layout,
    NewHumanPassed = true,
    NewComputerPassed = ComputerPass,
    write('Human passed'), nl.


takeTurn(4, HumanHand, ComputerHand, Boneyard, Layout, HumanPass, ComputerPassed, LeftEnd, RightEnd, NewHumanHand, NewComputerHand, NewLayout, NewBoneyard, NewHumanPassed, NewComputerPassed) :-
    
    help(HumanHand, LeftEnd, RightEnd, ComputerPassed, Boneyard),
    NewHumanHand = HumanHand,
    NewComputerHand = ComputerHand,
    NewBoneyard = Boneyard,
    NewLayout = Layout,
    NewHumanPassed = HumanPass,
    NewComputerPassed = ComputerPassed,
    write('Get help'), nl.





help(HumanHand, LeftEnd, RightEnd, ComputerPassed, Boneyard) :-

    write('Ha ha you need help'), nl,

    find_playable_tiles(HumanHand, LeftEnd, RightEnd, ComputerPassed, Options),

    (   Options == []
    ->  (   Boneyard == []
        ->  write("You can't draw or play anymore tiles. You have to pass"), nl
        ;   write('You have no playable tiles, you have to draw'), nl
        )
    ;   find_best_move(Options, HumanHand, LeftEnd, RightEnd, 0,
                        BestTile, BestIndex, BestSide),

        format("I recommend ~w on the ~w side~n", [BestTile, BestSide]),

        parse_tile(BestTile, A, B),

        (   ComputerPassed == true
        ->  write("Opponent passed! Try to disrupt their streak!"), nl
        ;   true
        ),

        (   A =:= B
        ->  write("Try to get rid of doubles early"), nl,
            write("Doubles placed strategically can disrupt opponent flow"), nl
        ;   TotalPipValue is A + B,
            format("Tile pip sum is ~w~n", [TotalPipValue]),
            write("Higher pip tiles can reduce penalty if you lose"), nl
        )
    ).

displayUI(TournScore, HumanHand, ComputerHand, Layout, Boneyard) :-
    write('_______________________________________'), nl,
    write('Tournament Score: '), nl,
    write(TournScore), nl,
    write('Round No.: '), nl,
    write(1), nl,
    write('_______________________________________'), nl, nl,

    write('Computer: '), nl,
    displayHand(ComputerHand), nl,

    write('Score: '), nl,
    %write(ComputerScore), nl,
    write('_______________________________________'), nl, nl,

    write('Human: '), nl,
    displayHand(HumanHand), nl,

    write('Score: '), nl,
    %write(HumanScore), nl,
    write('_______________________________________'), nl, nl,

    write('Layout: '), nl,
    displayLayout(Layout), nl,

    write('_______________________________________'), nl, nl,

    write('Boneyard: '), nl,
    displayBoneyard(Boneyard), nl,

    write('_______________________________________'), nl, nl.



% Case 1: Add to the Left
addTileToLayout(Tile, l, Layout, [Tile | Layout]).

% Case 2: Add to the Right
addTileToLayout(Tile, Side, Layout, NewLayout) :-
    Side == r,
    append(Layout, [Tile], NewLayout).

    
makeChoice(1) :-
    getTournamentScore(TournScore),
    newGame(HumanHand, ComputerHand, Layout, Boneyard,
            HumanHand1, ComputerHand1, Layout1, Boneyard1,
            CurrentPlayer, NextPlayer),


    gameLoop(Layout1, Boneyard1, 0, 1,
    false, false, 0, 0, TournScore,
    HumanHand1, ComputerHand1).

%makeChoice(2) :-
    %loadGame.

makeChoice(_) :-
    write('Invalid option'), nl.




displayList([]).
displayList([H|T]) :-
    write(H), write(' '),
    displayList(T).



displayHand(L) :- displayList(L).
displayLayout(L) :- displayList(L).
displayBoneyard(L) :- displayList(L).
