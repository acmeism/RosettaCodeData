#lang at-exp racket

(define raw-mapping @~a{
  maleS femaleS, maleness femaleness, him her, himself herself, his her, his
  hers, he she, Mr Mrs, Mister Missus, Ms Mr, Master Miss, MasterS MistressES,
  uncleS auntS, nephewS nieceS, sonS daughterS, grandsonS granddaughterS,
  brotherS sisterS, man woman, men women, boyS girlS, paternal maternal,
  grandfatherS grandmotherS, GodfatherS GodmotherS, GodsonS GoddaughterS,
  fiancéS fiancéeS, husband wife, husbands wives, fatherS motherS, bachelorS
  spinsterS, bridegroomS brideS, widowerS widowS, KnightS DameS, Sir DameS,
  KingS QueenS, DukeS DuchessES, PrinceS PrincessES, Lord Lady, Lords Ladies,
  MarquessES MarchionessES, EarlS CountessES, ViscountS ViscountessES, ladS
  lassES, sir madam, gentleman lady, gentlemen ladies, BaronS BaronessES,
  stallionS mareS, ramS eweS, coltS fillieS, billy nanny, billies nannies,
  bullS cowS, godS goddessES, heroS heroineS, shirtS blouseS, undies nickers,
  sweat glow, jackarooS jillarooS, gigoloS hookerS, landlord landlady,
  landlords landladies, manservantS maidservantS, actorS actressES, CountS
  CountessES, EmperorS EmpressES, giantS giantessES, heirS heiressES, hostS
  hostessES, lionS lionessES, managerS manageressES, murdererS murderessES,
  priestS priestessES, poetS poetessES, shepherdS shepherdessES, stewardS
  stewardessES, tigerS tigressES, waiterS waitressES, cockS henS, dogS bitchES,
  drakeS henS, dogS vixenS, tomS tibS, boarS sowS, buckS roeS, peacockS
  peahenS, gander goose, ganders geese, friarS nunS, monkS nunS, Adam Eve,
  Aaron Erin, Adrian Adriana, Aidrian Aidriana, Alan Alaina, Albert Alberta,
  Alex Alexa, Alex Alexis, Alexander Alaxandra, Alexander Alexandra, Alexander
  Alexis, Alexandra Alexander, Alexei Alexis, Alfred Alfreda, Andrew Andrea,
  Angel Angelica, Anthony Antonia, Antoine Antoinette, Ariel Arielle, Ashleigh
  Ashley, Barry Barrie, Benedict Benita, Benjamin Benjamine, Bert Bertha,
  Brandon Brandi, Brendan Brenda, Briana Brian, Brian Rianne, Caela Caesi,
  Caeleb Caeli, Carl Carla, Carl Carly, Carolus Caroline, Charles Caroline,
  Charles Charlotte, Christian Christa, Christian Christiana, Christian
  Christina, Christopher Christina, Christopher Christine, Clarence Claire,
  Claude Claudia, Clement Clementine, Cory Cora, Daniel Daniella, Daniel
  Danielle, David Davena, David Davida, David Davina, Dean Deanna, Devin
  Devina, Edward Edwina, Edwin Edwina, Emil Emilie, Emil Emily, Eric Erica,
  Erick Erica, Erick Ericka, Ernest Ernestine, Ethan Etha, Ethan Ethel, Eugene
  Eugenie, Fabian Fabia, Francesco Francesca, Frances Francesca, Francis
  Frances, Francis Francine, Frederick Fredrica, Fred Freda, Fredrick
  Frederica, Gabriel Gabriella, Gabriel Gabrielle, Gene Jean, George Georgia,
  George Georgina, Gerald Geraldine, Giovanni Giovanna, Glen Glenn, Harry
  Harriet, Harry Harriette, Heather Heath, Henry Henrietta, Horace Horatia, Ian
  Iana, Ilija Ilinka, Ivo Ivy, Ivan Ivy, Jack Jackelyn, Jack Jackie, Jack
  Jaclyn, Jack Jacqueline, Jacob Jacobine, James Jamesina, James Jamie, Jaun
  Jaunita, Jayda Jayden, Jesse Jessica, Jesse Jessie, Joe Johanna, Joel Joelle,
  John Jean, John Joan, John Johanna, Joleen Joseph, Jon Joane, Joseph
  Josephine, Joseph Josphine, Julian Julia, Julian Juliana, Julian Julianna,
  Justin Justine, Karl Karly, Kendrick Kendra, Ken Kendra, Kian Kiana, Kyle
  Kylie, Laurence Laura, Laurence Lauren, Laurence Laurencia, Leigh Leigha,
  Leon Leona, Louis Louise, Lucas Lucia, Lucian Lucy, Luke Lucia, Lyle Lyla,
  Maria Mario, Mario Maricela, Mark Marcia, Marshall Marsha, Martin martina,
  Martin Martine, Max Maxine, Michael Michaela, Michael Micheala, Michael
  Michelle, Mitchell Michelle, Nadir Nadira, Nicholas Nicole, Nicholas Nicki,
  Nicky Nikki, Nicolas Nicole, Nigel Nigella, Noel Noelle, Oen Ioena, Oliver
  Olivia, Patrick Patricia, Paul Paula, Phillip Phillipa, Phillip Pippa,
  Quintin Quintina, Reginald Regina, Richard Richardine, Robert Roberta, Robert
  Robyn, Ronald Rhonda, Ryan Rhian, Ryan Ryanne, Samantha Samuel, Samuel
  Samantha, Samuel Sammantha, Samuel Samuela, Sean Sian, Sean Siana, Shaun
  Shauna, Sheldon Shelby, Sonny Sunny, Stephan Stephanie, Stephen Stephanie,
  Steven Stephanie, Terry Carol, Terry Carrol, Theodore Theadora, Theodore
  Theodora, Theodore Theordora, Thomas Thomasina, Tristan Tricia, Tristen
  Tricia, Ulric Ulrika, Valentin Valentina, Victor Victoria, William
  Wilhelmina, William Willa, William Willamina, Xavier Xaviera, Yarden Yardena,
  Zahi Zahira, Zion Ziona})

(define flip-map (make-hash))

(for ([m (reverse (regexp-split #px"\\s*,\\s*" raw-mapping))])
  (define p (string-split m))
  (unless (= 2 (length p)) (error "Bad raw data"))
  (define (map! x y)
    (hash-set! flip-map (string-foldcase x) (string-foldcase y))
    (hash-set! flip-map (string-upcase x) (string-upcase y))
    (hash-set! flip-map (string-titlecase x) (string-titlecase y)))
  (define (2map! x y) (map! x y) (map! y x))
  (apply 2map! p)
  (apply 2map! (map (λ(x) (regexp-replace #rx"E?S$" x "")) p)))

(define (reverse-gender str)
  (regexp-replace* #px"\\w+" str
    (λ(word) (hash-ref flip-map word word))))

(displayln (reverse-gender @~a{
She was a soul stripper. She took my heart!

When a new-hatched savage running wild about his native
woodlands in a grass clout, followed by the nibbling goats, as if
he were a green sapling; even then, in Queequeg's ambitious soul,
lurked a strong desire to see something more of Christendom than
a specimen whaler or two. His father was a High Chief, a King;
his uncle a High Priest; and on the maternal side he boasted aunts
who were the wives of unconquerable warriors. There was excellent
blood in his veins-royal stuff; though sadly vitiated, I fear,
by the cannibal propensity he nourished in his untutored youth.
}))
