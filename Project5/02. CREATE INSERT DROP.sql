SET SERVEROUTPUT ON;

create or replace PROCEDURE DROP_TABLES_AND_SYNONYMS IS
V_COUNTER NUMBER := 0;
CURRENT_USER VARCHAR(10);
EX_INCORRECT_USER EXCEPTION;
BEGIN
    SELECT USER INTO CURRENT_USER FROM DUAL;
    IF (CURRENT_USER <> 'NAGPALM') THEN
        RAISE EX_INCORRECT_USER;
    END IF;
    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'RENT' AND TABLESPACE_NAME = 'DATA';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP TABLE RENT CASCADE CONSTRAINTS';       
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'DISCOUNT' AND TABLESPACE_NAME = 'DATA';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP TABLE DISCOUNT CASCADE CONSTRAINTS';       
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'BIKE' AND TABLESPACE_NAME = 'DATA';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP TABLE BIKE CASCADE CONSTRAINTS';       
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'DOCK' AND TABLESPACE_NAME = 'DATA';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP TABLE DOCK CASCADE CONSTRAINTS';       
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'TICKETING_QUEUE' AND TABLESPACE_NAME = 'DATA';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP TABLE TICKETING_QUEUE CASCADE CONSTRAINTS';       
    END IF;
    
    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'EMPLOYEE_STATE' AND TABLESPACE_NAME = 'DATA';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP TABLE EMPLOYEE_STATE CASCADE CONSTRAINTS';       
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'EMPLOYEE' AND TABLESPACE_NAME = 'DATA';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP TABLE EMPLOYEE CASCADE CONSTRAINTS';       
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'CUSTOMER' AND TABLESPACE_NAME = 'DATA';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP TABLE CUSTOMER CASCADE CONSTRAINTS';       
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'WALLET' AND TABLESPACE_NAME = 'DATA';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP TABLE WALLET CASCADE CONSTRAINTS';       
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'MEMBERSHIP' AND TABLESPACE_NAME = 'DATA';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP TABLE MEMBERSHIP CASCADE CONSTRAINTS';       
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_SYNONYMS WHERE OWNER = 'PUBLIC' AND SYNONYM_NAME = 'DISCOUNT';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM DISCOUNT';    
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_SYNONYMS WHERE OWNER = 'PUBLIC' AND SYNONYM_NAME = 'RENT';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM RENT';    
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_SYNONYMS WHERE OWNER = 'PUBLIC' AND SYNONYM_NAME = 'BIKE';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM BIKE';    
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_SYNONYMS WHERE OWNER = 'PUBLIC' AND SYNONYM_NAME = 'CUSTOMER';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM CUSTOMER';    
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_SYNONYMS WHERE OWNER = 'PUBLIC' AND SYNONYM_NAME = 'EMPLOYEE';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM EMPLOYEE';    
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_SYNONYMS WHERE OWNER = 'PUBLIC' AND SYNONYM_NAME = 'WALLET';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM WALLET';    
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_SYNONYMS WHERE OWNER = 'PUBLIC' AND SYNONYM_NAME = 'MEMBERSHIP';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM MEMBERSHIP';    
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_SYNONYMS WHERE OWNER = 'PUBLIC' AND SYNONYM_NAME = 'TICKETING_QUEUE';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM TICKETING_QUEUE';    
    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_SYNONYMS WHERE OWNER = 'PUBLIC' AND SYNONYM_NAME = 'DOCK';
    IF V_COUNTER > 0 THEN         
        EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM DOCK';    
    END IF;
    
    COMMIT;

    EXCEPTION
    WHEN EX_INCORRECT_USER THEN
        DBMS_OUTPUT.PUT_LINE('YOU CANNOT DO THIS ACTION. PLEASE CONTACT ADMIN');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;

END;
/

create or replace PROCEDURE CREATETABLES IS
   V_COUNTER NUMBER := 1;
   CURRENT_USER VARCHAR(10);
   EX_INCORRECT_USER EXCEPTION;
BEGIN
    SELECT USER INTO CURRENT_USER FROM DUAL;
    IF (CURRENT_USER <> 'NAGPALM') THEN
        RAISE EX_INCORRECT_USER;
    END IF;
    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'DISCOUNT' AND TABLESPACE_NAME = 'DATA';

    IF V_COUNTER = 0 THEN         

    EXECUTE IMMEDIATE '
    CREATE TABLE DISCOUNT(
    COUPON_ID NUMBER(2) PRIMARY KEY,
    COUPON_NAME VARCHAR(32) NOT NULL,
    COUPON_VALUE NUMBER(6,2) NOT NULL
    )';

    EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM DISCOUNT FOR NAGPALM.DISCOUNT';

    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'WALLET' AND TABLESPACE_NAME = 'DATA';

    IF V_COUNTER = 0 THEN         

    EXECUTE IMMEDIATE '
    CREATE TABLE WALLET(
    WALLET_ID NUMBER(6) PRIMARY KEY,
    BALANCE NUMBER(6,2) NOT NULL
    )';

    EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM WALLET FOR NAGPALM.WALLET';

    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'DOCK' AND TABLESPACE_NAME = 'DATA';

    IF V_COUNTER = 0 THEN         

    EXECUTE IMMEDIATE '
    CREATE TABLE DOCK(
    DOCK_ID NUMBER(3) PRIMARY KEY,
    DOCK_NAME VARCHAR(256) NOT NULL,
    CITY VARCHAR(32) NOT NULL,
    STATE VARCHAR(32) NOT NULL,
    ZIP_CODE VARCHAR(5) NOT NULL,
    LATITUDE NUMBER(8,6) NOT NULL,
    LONGITUDE NUMBER(9,6) NOT NULL
    )';

    EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM DOCK FOR NAGPALM.DOCK';

    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'BIKE' AND TABLESPACE_NAME = 'DATA';

    IF V_COUNTER = 0 THEN         

    EXECUTE IMMEDIATE '
    CREATE TABLE BIKE(
    BIKE_ID NUMBER(4) PRIMARY KEY,
    BIKE_MODEL VARCHAR(32) NOT NULL,
    DOCK_ID NUMBER(3) NOT NULL,
    FOREIGN KEY (DOCK_ID) REFERENCES DOCK (DOCK_ID),
    BIKE_STATUS VARCHAR(32) NOT NULL CHECK(BIKE_STATUS = ''AVAILABLE'' OR BIKE_STATUS = ''UNAVAILABLE'')
    )';

    EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM BIKE FOR NAGPALM.BIKE';

    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'MEMBERSHIP' AND TABLESPACE_NAME = 'DATA';

    IF V_COUNTER = 0 THEN         

    EXECUTE IMMEDIATE '
    CREATE TABLE MEMBERSHIP(
    MEMBERSHIP_ID NUMBER(1) PRIMARY KEY,
    MEMBERSHIP_TYPE VARCHAR(32) NOT NULL CHECK(MEMBERSHIP_TYPE = ''WEEKLY'' OR MEMBERSHIP_TYPE = ''MONTHLY'' OR MEMBERSHIP_TYPE = ''YEARLY''),
    MEMBERSHIP_AMOUNT NUMBER(6,2) NOT NULL
    )';

    EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM MEMBERSHIP FOR NAGPALM.MEMBERSHIP';

    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'CUSTOMER' AND TABLESPACE_NAME = 'DATA';

    IF V_COUNTER = 0 THEN         

    EXECUTE IMMEDIATE '
    CREATE TABLE CUSTOMER(
    CUSTOMER_ID NUMBER(5) PRIMARY KEY,
    FIRST_NAME VARCHAR(32) NOT NULL,
    LAST_NAME VARCHAR(32) NOT NULL,
    MOBILE_NUMBER NUMBER(10) NOT NULL,
    EMAIL_ID VARCHAR(32) NOT NULL UNIQUE,
    MEMBERSHIP_ID NUMBER(1),
    MEMBERSHIP_END_DATE DATE,
    CONSTRAINT FK_MEMBERSHIP FOREIGN KEY (MEMBERSHIP_ID)
    REFERENCES MEMBERSHIP (MEMBERSHIP_ID),
    WALLET_ID NUMBER(6) NOT NULL,
    CONSTRAINT FK_WALLET FOREIGN KEY (WALLET_ID)
    REFERENCES WALLET (WALLET_ID)
    )';

    EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM CUSTOMER FOR NAGPALM.CUSTOMER';

    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'RENT' AND TABLESPACE_NAME = 'DATA';

    IF V_COUNTER = 0 THEN         

    EXECUTE IMMEDIATE '
    CREATE TABLE RENT(
    RENT_ID NUMBER(7) PRIMARY KEY,
    PICKUP_TIME DATE NOT NULL,
    DROP_TIME DATE NOT NULL,
    BIKE_ID NUMBER(4) NOT NULL,
    CONSTRAINT FK_BIKE FOREIGN KEY (BIKE_ID)
    REFERENCES BIKE (BIKE_ID),
    CUSTOMER_ID NUMBER(5) NOT NULL,
    CONSTRAINT FK_CUSTOMER FOREIGN KEY (CUSTOMER_ID)
    REFERENCES CUSTOMER (CUSTOMER_ID),
    COUPON_ID NUMBER(2),
    CONSTRAINT FK_COUPONID FOREIGN KEY (COUPON_ID)
    REFERENCES DISCOUNT (COUPON_ID),
    PAYMENT_STATUS VARCHAR(10) CHECK(PAYMENT_STATUS = ''PAID'' OR PAYMENT_STATUS = ''UNPAID'')
    )';

    EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM RENT FOR NAGPALM.RENT';

    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'EMPLOYEE' AND TABLESPACE_NAME = 'DATA';

    IF V_COUNTER = 0 THEN         

    EXECUTE IMMEDIATE '
    CREATE TABLE EMPLOYEE(
    EMPLOYEE_ID NUMBER(8) PRIMARY KEY,
    FIRST_NAME VARCHAR(256) NOT NULL,
    LAST_NAME VARCHAR(256) NOT NULL,
    EMAIL_ID VARCHAR(256) NOT NULL UNIQUE,
    MOBILE_NUMBER NUMBER(10) NOT NULL,
    DOB DATE NOT NULL,
    GENDER VARCHAR(6) NOT NULL CHECK(GENDER = ''MALE'' OR GENDER = ''FEMALE'' OR GENDER = ''OTHER''),
    DESIGNATION VARCHAR(256) NOT NULL,
    REPORTING_MANAGER NUMBER(8)
    )';

    EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM EMPLOYEE FOR NAGPALM.EMPLOYEE';

    END IF;

    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'TICKETING_QUEUE' AND TABLESPACE_NAME = 'DATA';

    IF V_COUNTER = 0 THEN         

    EXECUTE IMMEDIATE '
    CREATE TABLE TICKETING_QUEUE(
    TICKET_ID NUMBER(9) PRIMARY KEY,
    CUSTOMER_ID NUMBER(5) NOT NULL,
    CONSTRAINT FK_CUSTOMERS FOREIGN KEY (CUSTOMER_ID)
    REFERENCES CUSTOMER (CUSTOMER_ID),
    TICKET_AGENT NUMBER(8) NOT NULL,
    CONSTRAINT FK_AGENTS FOREIGN KEY (TICKET_AGENT)
    REFERENCES EMPLOYEE (EMPLOYEE_ID),
    TICKET_DESC VARCHAR(32) NOT NULL,
    TICKET_STATUS VARCHAR(10) NOT NULL CHECK(TICKET_STATUS = ''ASSIGNED'' OR TICKET_STATUS = ''CLOSED'')
    )';

    EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM TICKETING_QUEUE FOR NAGPALM.TICKETING_QUEUE';

    END IF;
    
    SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'EMPLOYEE_STATE' AND TABLESPACE_NAME = 'DATA';

    IF V_COUNTER = 0 THEN         

    EXECUTE IMMEDIATE '
    CREATE TABLE EMPLOYEE_STATE(
    EMPLOYEE_ID NUMBER(8) PRIMARY KEY,
    EMPLOYEE_STATUS VARCHAR(32) DEFAULT ON NULL ''AVAILABLE'' CHECK(EMPLOYEE_STATUS = ''AVAILABLE'' OR EMPLOYEE_STATUS = ''UNAVAILABLE'')
    )';

    EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM EMPLOYEE_STATE FOR NAGPALM.EMPLOYEE_STATE';

    END IF;

    COMMIT;

    EXCEPTION
    WHEN EX_INCORRECT_USER THEN
        DBMS_OUTPUT.PUT_LINE('YOU CANNOT DO THIS ACTION. PLEASE CONTACT ADMIN');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;

END;
/

CREATE OR REPLACE PROCEDURE DELETE_SEQUENCE_USER(OBJNAME VARCHAR2,OBJTYPE VARCHAR2)
IS
    V_COUNTER NUMBER := 0;
    CURRENT_USER VARCHAR(10);
    EX_INCORRECT_USER EXCEPTION;
BEGIN
    SELECT USER INTO CURRENT_USER FROM DUAL;
    IF (CURRENT_USER <> 'NAGPALM') THEN
        RAISE EX_INCORRECT_USER;
    END IF;
    IF OBJTYPE = 'SEQUENCE' THEN
        SELECT COUNT(*) INTO V_COUNTER FROM USER_SEQUENCES WHERE SEQUENCE_NAME = UPPER(OBJNAME);
            IF V_COUNTER > 0 THEN          
                EXECUTE IMMEDIATE 'DROP SEQUENCE ' || OBJNAME;        
            END IF; 
    END IF;
    IF OBJTYPE = 'USER' THEN
        SELECT COUNT(*) INTO V_COUNTER FROM ALL_USERS WHERE USERNAME = UPPER(OBJNAME);
            IF V_COUNTER > 0 THEN          
                EXECUTE IMMEDIATE 'DROP USER ' || OBJNAME;        
            END IF; 
    END IF;
    COMMIT;
    EXCEPTION
    WHEN EX_INCORRECT_USER THEN
        DBMS_OUTPUT.PUT_LINE('YOU CANNOT DO THIS ACTION. PLEASE CONTACT ADMIN');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;
END;
/

EXECUTE DROP_TABLES_AND_SYNONYMS;
EXECUTE CREATETABLES;

EXECUTE DELETE_SEQUENCE_USER('MEMBERSHIP_ID_SEQUENCE','SEQUENCE'); 
CREATE SEQUENCE MEMBERSHIP_ID_SEQUENCE
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
EXECUTE DELETE_SEQUENCE_USER('COUPON_ID_SEQUENCE','SEQUENCE'); 
CREATE SEQUENCE COUPON_ID_SEQUENCE
    START WITH 10
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
EXECUTE DELETE_SEQUENCE_USER('DOCK_ID_SEQUENCE','SEQUENCE'); 
CREATE SEQUENCE DOCK_ID_SEQUENCE
    START WITH 100
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
EXECUTE DELETE_SEQUENCE_USER('BIKE_ID_SEQUENCE','SEQUENCE'); 
CREATE SEQUENCE BIKE_ID_SEQUENCE
    START WITH 1000
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
EXECUTE DELETE_SEQUENCE_USER('CUSTOMER_ID_SEQUENCE','SEQUENCE'); 
CREATE SEQUENCE CUSTOMER_ID_SEQUENCE
    START WITH 10000
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
EXECUTE DELETE_SEQUENCE_USER('WALLET_ID_SEQUENCE','SEQUENCE'); 
CREATE SEQUENCE WALLET_ID_SEQUENCE
    START WITH 100000
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
EXECUTE DELETE_SEQUENCE_USER('RENT_ID_SEQUENCE','SEQUENCE'); 
CREATE SEQUENCE RENT_ID_SEQUENCE
    START WITH 1000000
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

EXECUTE DELETE_SEQUENCE_USER('EMPLOYEE_ID_SEQUENCE','SEQUENCE'); 
CREATE SEQUENCE EMPLOYEE_ID_SEQUENCE
    START WITH 10000000
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

EXECUTE DELETE_SEQUENCE_USER('TICKET_ID_SEQUENCE','SEQUENCE'); 
CREATE SEQUENCE TICKET_ID_SEQUENCE
    START WITH 100000000
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

--INSERTS IN MEMBERSHIP
INSERT INTO MEMBERSHIP (MEMBERSHIP_ID, MEMBERSHIP_TYPE, MEMBERSHIP_AMOUNT) VALUES (MEMBERSHIP_ID_SEQUENCE.NEXTVAL,'WEEKLY',30.55);
INSERT INTO MEMBERSHIP (MEMBERSHIP_ID, MEMBERSHIP_TYPE, MEMBERSHIP_AMOUNT) VALUES (MEMBERSHIP_ID_SEQUENCE.NEXTVAL,'MONTHLY',110.50);
INSERT INTO MEMBERSHIP (MEMBERSHIP_ID, MEMBERSHIP_TYPE, MEMBERSHIP_AMOUNT) VALUES (MEMBERSHIP_ID_SEQUENCE.NEXTVAL,'YEARLY',1190.00);


--INSERTS IN DISCOUNT
INSERT INTO DISCOUNT (COUPON_ID, COUPON_NAME, COUPON_VALUE) VALUES (COUPON_ID_SEQUENCE.NEXTVAL,'BEBLUE',20);
INSERT INTO DISCOUNT (COUPON_ID, COUPON_NAME, COUPON_VALUE) VALUES (COUPON_ID_SEQUENCE.NEXTVAL,'SAVE10',10);
INSERT INTO DISCOUNT (COUPON_ID, COUPON_NAME, COUPON_VALUE) VALUES (COUPON_ID_SEQUENCE.NEXTVAL,'SAVE05',5);
INSERT INTO DISCOUNT (COUPON_ID, COUPON_NAME, COUPON_VALUE) VALUES (COUPON_ID_SEQUENCE.NEXTVAL,'SAVE03',3);


--INSERTS IN DOCK AND BIKE
INSERT INTO DOCK (DOCK_ID, DOCK_NAME, CITY, STATE, ZIP_CODE, LATITUDE, LONGITUDE) VALUES (DOCK_ID_SEQUENCE.NEXTVAL,'1200 BEACON ST','BROOKLINE','MASSACHUSETTS','02446',42.3441489,-71.1146736);
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO DOCK (DOCK_ID, DOCK_NAME, CITY, STATE, ZIP_CODE, LATITUDE, LONGITUDE) VALUES (DOCK_ID_SEQUENCE.NEXTVAL,'160 ARSENAL','WATERTOWN','MASSACHUSETTS','02472',42.364664,-71.1756938);
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2015',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2015',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2015',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO DOCK (DOCK_ID, DOCK_NAME, CITY, STATE, ZIP_CODE, LATITUDE, LONGITUDE) VALUES (DOCK_ID_SEQUENCE.NEXTVAL,'175 N HARVARD ST','BOSTON','MASSACHUSETTS','02134',42.363796,-71.129164);
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2015',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2015',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2015',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO DOCK (DOCK_ID, DOCK_NAME, CITY, STATE, ZIP_CODE, LATITUDE, LONGITUDE) VALUES (DOCK_ID_SEQUENCE.NEXTVAL,'191 BEACON ST','SOMERVILLE','MASSACHUSETTS','02116',42.3803233,-71.1087861);
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2010',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO DOCK (DOCK_ID, DOCK_NAME, CITY, STATE, ZIP_CODE, LATITUDE, LONGITUDE) VALUES (DOCK_ID_SEQUENCE.NEXTVAL,'2 HUMMINGBIRD LANE AT OLMSTED GREEN','BOSTON','MASSACHUSETTS','02126',42.28887,-71.095003);
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2015',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2015',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2015',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2015',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2015',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2015',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'AVAILABLE');
INSERT INTO BIKE (BIKE_ID, BIKE_MODEL, DOCK_ID, BIKE_STATUS) VALUES (BIKE_ID_SEQUENCE.NEXTVAL,'BLU2020',DOCK_ID_SEQUENCE.CURRVAL,'UNAVAILABLE');


--INSERTS INTO EMPLOYEE
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'LILLIAN','WALKER','LILLIAN.WALKER@BBIKES.COM',1910872484,'27NOV97','FEMALE','MANAGER',NULL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'DIANE','ROBINSON','DIANE.ROBINSON@BBIKES.COM',1279518760,'25JAN95','FEMALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'BENJAMIN','ROBINSON','BENJAMIN.ROBINSON@BBIKES.COM',8451090345,'09JAN97','MALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'PATRICK','EVANS','PATRICK.EVANS@BBIKES.COM',2919637853,'20FEB86','MALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'JACK','RUSSELL','JACK.RUSSELL@BBIKES.COM',1171612017,'15NOV95','MALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'MELISSA','BAILEY','MELISSA.BAILEY@BBIKES.COM',3791405074,'05AUG97','FEMALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'WAYNE','BAKER','WAYNE.BAKER@BBIKES.COM',9901419828,'20OCT96','MALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'CHERYL','MITCHELL','CHERYL.MITCHELL@BBIKES.COM',4507868433,'22DEC85','FEMALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'PAULA','WILSON','PAULA.WILSON@BBIKES.COM',9406996076,'06DEC87','FEMALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'JOSHUA','PRICE','JOSHUA.PRICE@BBIKES.COM',1948638557,'20JUN97','MALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'THERESA','BROWN','THERESA.BROWN@BBIKES.COM',2796003432,'18JUN93','FEMALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'JULIA','COLLINS','JULIA.COLLINS@BBIKES.COM',7415401255,'25DEC87','FEMALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'THOMAS','JENKINS','THOMAS.JENKINS@BBIKES.COM',8154154939,'30MAY97','MALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'MARIA','BROWN','MARIA.BROWN@BBIKES.COM',8188721494,'07FEB86','FEMALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL_ID, MOBILE_NUMBER, DOB, GENDER, DESIGNATION, REPORTING_MANAGER) VALUES (EMPLOYEE_ID_SEQUENCE.NEXTVAL,'BRENDA','HOWARD','BRENDA.HOWARD@BBIKES.COM',4539315497,'23FEB92','FEMALE','CUSTOMER TECHNICIAN', (SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE DESIGNATION = 'MANAGER'));
--INSERT INTO EMPLOYEE_STATE (EMPLOYEE_ID) VALUES (EMPLOYEE_ID_SEQUENCE.CURRVAL);

--INSERTS IN WALLET, CUSTOMER AND TICKETING_QUEUE
INSERT INTO WALLET (WALLET_ID, BALANCE) VALUES (WALLET_ID_SEQUENCE.NEXTVAL,500.2);
INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, MOBILE_NUMBER, EMAIL_ID, MEMBERSHIP_ID, MEMBERSHIP_END_DATE, WALLET_ID) VALUES (CUSTOMER_ID_SEQUENCE.NEXTVAL,'LOIS','WALKER',2016268722,'LOIS.WALKER@HOTMAIL.COM',1,CURRENT_DATE + 7 ,WALLET_ID_SEQUENCE.CURRVAL);
INSERT INTO TICKETING_QUEUE (TICKET_ID, CUSTOMER_ID, TICKET_AGENT, TICKET_DESC, TICKET_STATUS) VALUES (TICKET_ID_SEQUENCE.NEXTVAL, CUSTOMER_ID_SEQUENCE.CURRVAL,10000000,'MEMBERSHIP RENEWAL ISSUES','ASSIGNED');

INSERT INTO WALLET (WALLET_ID, BALANCE) VALUES (WALLET_ID_SEQUENCE.NEXTVAL,400.5);
INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, MOBILE_NUMBER, EMAIL_ID, MEMBERSHIP_ID, MEMBERSHIP_END_DATE,WALLET_ID) VALUES (CUSTOMER_ID_SEQUENCE.NEXTVAL,'BRENDA','ROBINSON',2066707016,'BRENDA.ROBINSON@GMAIL.COM',3,CURRENT_DATE + 365,WALLET_ID_SEQUENCE.CURRVAL);
INSERT INTO TICKETING_QUEUE (TICKET_ID, CUSTOMER_ID, TICKET_AGENT,TICKET_DESC, TICKET_STATUS) VALUES (TICKET_ID_SEQUENCE.NEXTVAL, CUSTOMER_ID_SEQUENCE.CURRVAL,10000005,'RENT OVERCHARGING ISSUE','ASSIGNED');

INSERT INTO WALLET (WALLET_ID, BALANCE) VALUES (WALLET_ID_SEQUENCE.NEXTVAL,300.25);
INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, MOBILE_NUMBER, EMAIL_ID, MEMBERSHIP_ID, MEMBERSHIP_END_DATE,WALLET_ID) VALUES (CUSTOMER_ID_SEQUENCE.NEXTVAL,'JOE','ROBINSON',5089040452,'JOE.ROBINSON@GMAIL.COM',2,CURRENT_DATE + 30,WALLET_ID_SEQUENCE.CURRVAL);
INSERT INTO TICKETING_QUEUE (TICKET_ID, CUSTOMER_ID, TICKET_AGENT,TICKET_DESC, TICKET_STATUS) VALUES (TICKET_ID_SEQUENCE.NEXTVAL, CUSTOMER_ID_SEQUENCE.CURRVAL,10000012,'RIDE EXTENSION ISSUE', 'CLOSED');

INSERT INTO WALLET (WALLET_ID, BALANCE) VALUES (WALLET_ID_SEQUENCE.NEXTVAL,999.99);
INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, MOBILE_NUMBER, EMAIL_ID, MEMBERSHIP_ID, MEMBERSHIP_END_DATE,WALLET_ID) VALUES (CUSTOMER_ID_SEQUENCE.NEXTVAL,'DIANE','EVANS',3609196987,'DIANE.EVANS@YAHOO.COM',2,CURRENT_DATE + 30,WALLET_ID_SEQUENCE.CURRVAL);
INSERT INTO TICKETING_QUEUE (TICKET_ID, CUSTOMER_ID, TICKET_AGENT, TICKET_DESC, TICKET_STATUS) VALUES (TICKET_ID_SEQUENCE.NEXTVAL, CUSTOMER_ID_SEQUENCE.CURRVAL,10000008,'COUPON ISSUE', 'ASSIGNED');

INSERT INTO WALLET (WALLET_ID, BALANCE) VALUES (WALLET_ID_SEQUENCE.NEXTVAL,50.5);
INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, LAST_NAME, MOBILE_NUMBER, EMAIL_ID, MEMBERSHIP_ID, MEMBERSHIP_END_DATE,WALLET_ID) VALUES (CUSTOMER_ID_SEQUENCE.NEXTVAL,'BENJAMIN','RUSSELL',6176719370,'BENJAMIN.RUSSELL@CHARTER.NET',1,CURRENT_DATE + 7,WALLET_ID_SEQUENCE.CURRVAL);


--INSERTS IN RENT
INSERT INTO RENT (RENT_ID,CUSTOMER_ID,BIKE_ID,PICKUP_TIME,DROP_TIME,COUPON_ID,PAYMENT_STATUS)
VALUES(RENT_ID_SEQUENCE.NEXTVAL,10000,1001,CURRENT_DATE,CURRENT_DATE + INTERVAL '60' MINUTE,11,'PAID');

INSERT INTO RENT (RENT_ID,CUSTOMER_ID,BIKE_ID,PICKUP_TIME,DROP_TIME,COUPON_ID,PAYMENT_STATUS)
VALUES(RENT_ID_SEQUENCE.NEXTVAL,10001,1002,CURRENT_DATE,CURRENT_DATE + INTERVAL '60' MINUTE,NULL,'PAID');

INSERT INTO RENT (RENT_ID,CUSTOMER_ID,BIKE_ID,PICKUP_TIME,DROP_TIME,COUPON_ID,PAYMENT_STATUS)
VALUES(RENT_ID_SEQUENCE.NEXTVAL,10002,1003,CURRENT_DATE,CURRENT_DATE + INTERVAL '60' MINUTE,12,'PAID');

INSERT INTO RENT (RENT_ID,CUSTOMER_ID,BIKE_ID,PICKUP_TIME,DROP_TIME,COUPON_ID,PAYMENT_STATUS)
VALUES(RENT_ID_SEQUENCE.NEXTVAL,10003,1004,CURRENT_DATE,CURRENT_DATE + INTERVAL '60' MINUTE,13,'UNPAID');

INSERT INTO RENT (RENT_ID,CUSTOMER_ID,BIKE_ID,PICKUP_TIME,DROP_TIME,COUPON_ID,PAYMENT_STATUS)
VALUES(RENT_ID_SEQUENCE.NEXTVAL,10004,1005,CURRENT_DATE,CURRENT_DATE + INTERVAL '60' MINUTE,11,'UNPAID');

COMMIT;
