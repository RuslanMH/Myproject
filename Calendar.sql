/*
�������� ������� Calendar
*/
 CREATE TABLE CALENDAR
   (ID NUMBER CONSTRAINT CALENDAR_PK PRIMARY KEY,
	DAY_X DATE, 
	WEEKLE NUMBER) 



/*
�������� �������� ��� ������� �������
*/
CREATE SEQUENCE S_CALENDAR INCREMENT BY 1 MAXVALUE 1825 MINVALUE 1 CYCLE CACHE 20 ORDER;




/*
�������� ��������, ������� ����� ������������ �������, ��� ������� id, ��� �������� �������.
*/
create or replace NONEDITIONABLE TRIGGER calendar_ai
BEFORE INSERT on calendar
REFERENCING NEW AS N OLD AS O
FOR EACH ROW
begin
select s_calendar.nextval
into :n.id
from dual;
end;




/* 
������� ������ � ������� � ����� ������, ���� Day_x ���������� ����, � ���������� �������
���� 2021 ���, ������ ���� ��������� �������� 1 ��� 0, ��� 0 ������� ����, 1 ��������. 
*/
INSERT into calendar (Day_x,weekle) 
SELECT t.day, case when t.wrk is not null THEN t.wrk else greatest(t.wknd,t.hld) end as f_wknd_hld 
FROM (SELECT trunc(sysdate,'y')-1+level as day, 
      DECODE(TO_CHAR(trunc(sysdate,'y') + LEVEL-1, 'D'),
       6,1,
       7,1,
       0) as wknd ,
        
       DECODE((trunc(sysdate,'y') + LEVEL-1),-- �������� ������� �� ������������� �������� ��� ����������� �� �������� ����      
       to_date ('20.02.21'),0,
       null) as wrk,
   
       DECODE((trunc(sysdate,'y') + LEVEL-1),-- ��� ����������� ��� � ����  
             to_date ('01.01.21'),1,
             to_date ('02.01.21'),1,
             to_date ('03.01.21'),1,
             to_date ('04.01.21'),1,
             to_date ('05.01.21'),1,
             to_date ('06.01.21'),1,
             to_date ('07.01.21'),1,
             to_date ('08.01.21'),1,
             to_date ('22.02.21'),1,
             to_date ('23.02.21'),1,
             to_date ('08.03.21'),1,
             to_date ('03.05.21'),1,
             to_date ('10.05.21'),1,
             to_date ('14.06.21'),1,
             to_date ('04.11.21'),1,
             to_date ('05.11.21'),1,
             to_date ('31.12.21'),1,
             0) as hld
             
from dual 
connect by level <= add_months( trunc(sysdate,'y'),12) - trunc (sysdate,'y'))T





/*
�������� ������� count_wrk_day, ������� ��������� ��� �������� ��������
���� date, � ������ �������� ���� number � ������������ ������� ���� � ��������� 
�������� ��������
*/
CREATE FUNCTION count_wrk_day
(frs_date in date,lst_date in date) RETURN number is
count_day number;
BEGIN
  SELECT COUNT(1)
  INTO count_day
  FROM calendar
  where day_x BETWEEN frs_date and lst_date
  and weekle = 0;
  return count_day;
END count_wrk_day;

/*
����� ������� ��� ��������
*/
SELECT count_wrk_day ('15,03,21','26,07,21')
FROM dual