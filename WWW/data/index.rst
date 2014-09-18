Course Datasets
===============

earlydeaths.csv
---------------

Juvenile Deaths in Santa Clara County

:download:`Click to download data </datasets/earlydeaths.csv>`

Fields:

* **time**: Time of death (1, 2, or 3; corresponding to 1990-91, 1992-93, 1994-95)
* **cause**: Cause of each juvenile's death ('maltreatment' or 'other')


fieldsimul1.csv
---------------

Survey of likely voters in California

:download:`Click to download data </datasets/fieldsimul1.csv>`

Fields:

* **age**: Age of voters surveyed (20-75 years)
* **agecat**: Age of voters surveyed, binned into groups of 20 years
* **party**: Political party of voters (1=Democrat, 2=Republican, 3=Other)
* **prop54**: Whether voter reported if they would vote for Prop 54 (Racial Privacy Initiative)
* **optmism**: Level of optimism (0-11)
* **recall**: Do you think the governor should be recalled? (1=yes, 2=no, 3=unsure)
* **recallq**: Do you think the governor should be recalled? (1=yes, 0=unsure, -1=no)


hw2data.csv
-----------

Study of memory biases

:download:`Click to download data </datasets/hw2data.csv>`

Fields:

* **Type**: Experimental condition (1=free, 2=biased, 3=varied)
* **Pasthap**: Rating of recalled happiness
* **Responsible**: Self-reported feelings of responsibility
* **Futurehapp**: Rating of expected future happiness
* **FTP**: Future time perspective
* **complain**: Yes/no response for whether participants considered complaining


acupuncture.csv
---------------

Survey of acupuncture and traditional medicine patients

:download:`Click to download data </datasets/acupuncture.csv>`

Fields:

* **treatment**: Treatment type (1 = 'real' acupuncture; 2 = traditional)
* **exercise**: Level of patient's exercise
* **otc**: Whether participants take over the counter medicine (1 = Yes, 2 = No)
* **time**: Elapsed time (in years) since symptom onset
* **relief**: Level of pain relief

metanalysis.csv
---------------

Metanalysis of 79 studies interested in the efficacy of acupuncture at treating chronic pain

:download:`Click to download data </datasets/metanalysis.csv>`

Fields:

* **effect_size**: Cohens *d* such that positive values indicate that acupuncture groups did better than control groups
* **total_N**: Total number of patients involved in the study
* **symptoms**: The primary symptom the patient was being seen for

mentillness.csv
---------------
Data from a study about how jurors’ perceptions of a defendant as ‘mentally ill’ might affect their perceptions 
of defendant guilt. Participants are asked to read a carefully pretested case outline and then to answer questions 
about the case. The case outline states the main facts of a robbery, including eye-witness testimony about the 
identity and behavior of the robber.


:download:`Click to download data </datasets/mentillness.csv>`

Fields:

* **guilt**: Self-reported belief that the defendant is guilty (1 = Definitely Not Guilty, 2 = Probably Not Guilty, 3 = Probably Guilty, or 4 = Definitely Guilty) 
* **mentill**:  Self-reported belief that the defendant is mentally ill (1 = Yes or 0 = No)
* **futhrt**:  Self-reported belief that the defendant is a future threat to society (scale from 0 [Very Low] to 10 [Very High])
* **futthcat**:  Self-reported belief that the defendant is a future threat to society (binning together extreme responses [0-2; 3; 4; 5; 6-10])

families.csv
---------------

Data from a study of 68 companies, examining relationships between the quality of family-friendly programs at each company, the percentage of employees with families who use these programs, and employee satisfaction (all continuous variables).

:download:`Click to download data </datasets/families.csv>`

Fields:

* **famprog**: the amount of family-friendly programs from (1 = Nothing at all to 9 = Amazing family-friendliness)
* **perfam**: the percentage of employees with families in the organization (from 0% to 100%)
* **empastis**: the average rating of employee satisfaction (1 = Extremely unsatisfied to 7 = Extremely satisfied)

hw4motive.csv
---------------

Data from 3 groups of 20 students who drank either 0, 2, or 4 cups of coffee and then took a 10-problem statistics quiz. Examines possible mediators of accuracy and hyperactivity.

:download:`Click to download data </datasets/hw4motive.csv>`

Fields:

* **difficulty**: challenge of a task (probability of finishing the task unsuccessfully) (1= low, 5 = high)

* **score**: how well a person does on a task (0 - 10)

* **train**: either a novice or expert, categorical

lifesatis.csv
---------------

Data with predictors of life satisfaction among 62 working married men between the age of 20 and 70. 

:download:`Click to download data </datasets/lifesatis.csv>`

Fields:

* **id**: Subject ID (1-62)

* **age**: Age (21-68)

* **kids**: number of children (0-8)

* **jobsatis**: current job satisfaction (1 to 7)

* **marsatis**: current marital satisfaction (1 to 7)

* **lifsatis**: current overall life satisfaction (1 to 7)

performance.csv
---------------

Dataset from an educational psychologist, testing the effectiveness of 3 methods of mathematics instruction in a study, 20 students being trained by each method.

:download:`Click to download data </datasets/performance.csv>`

Fields:

* **method**: method of instruction, 1 = emphasizing 'drill and practice,' 2  =

emphasizing fun with math, and 3 = control method 

* **satis**: student satisfaction with the method 

* **time**: time each student spent doing or talking about math during the school day (12 to 26)

* **ability**: student's score on a standardized math test a year ago

* **perform**: student's score on a standardized math test after training

caffeine.csv
---------------

Data from 3 groups of 20 students who drank either 0, 2, or 4 cups of coffee and then took a 10-problem statistics quiz. Examines possible mediators of accuracy and hyperactivity.

:download:`Click to download data </datasets/caffeine.csv>`

Fields:

* **coffee**: each group had either 0 cups, 2 cups, or 4 cups (coded in dataset as group 1, 2, or 3)

* **perf**: score on a stats quiz with 10 problems

* **numprob**: number of problems attempted (hyperactivity)

* **accur**: likelihood of getting a problem right if they tried (better success)

kv0.csv
---------------

Repeated measures design with features both between-subject factors (2 attention conditions) and within-subject factors (# of possible solutions to a word task, solving anagrams). The dependent variable was score on a memory test (higher numbers reflect better performance). There were 10 study participants divided between the two conditions; they each completed three problems in each category of # of possible solutions (1, 2, or 3).

:download:`Click to download data </datasets/kv0.csv>`

Fields:

* **subidr**: Subject ID

* **attnr**: 1 = divided attention condition; 2 = focused attention condition

* **num1**: only one solution to the anagram

* **num2**: two possible solutions to the anagram

* **num3**: three possible solutions to the anagram

exer.csv
---------------

30 people were randomly assigned to two different diets (low-fat and not low-fat) and three different types of exercise (at rest, walking leisurely and running). Their pulse rate was measured at three different time points during their assigned exercise (at 1 minute, 15 minutes and 30 minutes).

:download:`Click to download data </datasets/exer.csv>`

Fields:

* **id**: Subject ID

* **diet**: 1 = low fat; 2 = not low fat

* **exertype**: 1 = at rest, 2 = walking, 3 = running

* **pulse**

* **time**: 1 = 1 min, 2 = 15 min, 3 = 30 min

timeflies.csv
---------------

40 participants were presented with 20 sound clips, varying in length from 30 to 90 seconds. Ten were taken from funny comedy routines, while ten were taken from the podcast of a tedious statistics class (the two groups have the same average length). After a delay, participants are asked to indicate how fun each clip was to listen to (on a scale to 0, not fun at all, to 7, a total blast), and to estimate how long (in seconds) the clip lasted. Each column corresponds to a rating, such that, for example, “comclip1.rat” is the rating of the first comedy clip, while “statsclip10.len” is the estimated length of the tenth stats clip for the same participant, etc.

:download:`Click to download data </datasets/timeflies.csv>`

Fields:

* **comclip.rat**: rating of comedy clips

* **statsclip.rat**: rating of statistics class clips

* **comclip.len**: perceived length of comedy clips

* **statsclip.len**: perceived length of statistics class clips