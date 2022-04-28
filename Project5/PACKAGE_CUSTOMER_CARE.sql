CREATE OR REPLACE PACKAGE CUSTOMER_ACTIONS
AS
    PROCEDURE CURRENT_BALANCE(EMAIL IN CUSTOMER.EMAIL_ID%TYPE, O_BAL OUT WALLET.BALANCE%TYPE);
    
    PROCEDURE ADD_BALANCE(EMAIL IN CUSTOMER.EMAIL_ID%TYPE, NEW_BAL IN WALLET.BALANCE%TYPE);
    
    PROCEDURE CUSTOMER_REGISTRATION(F_NAME IN CUSTOMER.FIRST_NAME%TYPE,L_NAME IN CUSTOMER.LAST_NAME%TYPE,
                                    MOB_NO IN CUSTOMER.MOBILE_NUMBER%TYPE, EMAIL IN CUSTOMER.EMAIL_ID%TYPE);
                                    
    PROCEDURE END_RIDE(EMAIL IN CUSTOMER.EMAIL_ID%TYPE, D_ID IN BIKE.DOCK_ID%TYPE,C_NAME IN DISCOUNT.COUPON_NAME%TYPE);
     
    PROCEDURE MAKE_PAYMENT(EMAIL IN CUSTOMER.EMAIL_ID%TYPE);
    
    PROCEDURE PRINT_MEMBERSHIP_OPTIONS;
    
    PROCEDURE PRINT_ISSUE_OPTIONS;
    
    PROCEDURE START_RIDE(B_ID IN BIKE.BIKE_ID%TYPE, EMAIL IN CUSTOMER.EMAIL_ID%TYPE);
    
    PROCEDURE TICKET_CREATION(EMAIL IN CUSTOMER.EMAIL_ID%TYPE, T_TYPE IN TICKETING_QUEUE.TICKET_DESC%TYPE);
    
    PROCEDURE UPDATE_CUSTOMER_DETAILS(EMAIL IN CUSTOMER.EMAIL_ID%TYPE, ISS_TYPE IN VARCHAR, ISS_VALUE IN VARCHAR);
    
    PROCEDURE UPDATE_CUSTOMER_OPTIONS;
   
END CUSTOMER_ACTIONS;
/

CREATE OR REPLACE PACKAGE BODY CUSTOMER_ACTIONS AS

    PROCEDURE ADD_BALANCE(EMAIL IN CUSTOMER.EMAIL_ID%TYPE, NEW_BAL IN WALLET.BALANCE%TYPE) AS
    VAL NUMBER;
    W_ID WALLET.WALLET_ID%TYPE;
    BAL WALLET.BALANCE%TYPE;
    DOES_NOT_EXIST EXCEPTION;
    EX_EMAIL_NULL EXCEPTION;
    USER_EXISTS_EXCEP EXCEPTION;
    BAL_NULL EXCEPTION;
BEGIN    
    EXECUTE IMMEDIATE ('SELECT COUNT(*) from (SELECT 1 from dual where REGEXP_LIKE ('''||EMAIL||''', ''^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$''))') INTO VAL;

    IF LENGTH(UPPER(EMAIL)) IS NULL OR VAL<1 THEN
        RAISE EX_EMAIL_NULL;
    END IF;

    IF NEW_BAL IS NULL  OR NEW_BAL<0 THEN
        RAISE BAL_NULL;
    END IF;

    EXECUTE IMMEDIATE ('SELECT COUNT(*) FROM (SELECT WALLET_ID FROM CUSTOMER WHERE EMAIL_ID='''||EMAIL||''')') INTO VAL;

    IF VAL=0 THEN
        RAISE DOES_NOT_EXIST;
    END IF;

    EXECUTE IMMEDIATE ('SELECT WALLET_ID FROM CUSTOMER WHERE EMAIL_ID='''||EMAIL||'''') INTO W_ID;
    EXECUTE IMMEDIATE ('SELECT BALANCE FROM WALLET WHERE WALLET_ID='||W_ID) INTO BAL;

    BAL:= BAL+NEW_BAL;
    EXECUTE IMMEDIATE ('UPDATE WALLET SET BALANCE=' ||BAL|| ' WHERE WALLET_ID = '||W_ID);

    DBMS_OUTPUT.PUT_LINE('BALANCE FOR '||EMAIL||'  IS '||BAL);
    COMMIT;

    EXCEPTION
    WHEN BAL_NULL THEN
        DBMS_OUTPUT.PUT_LINE('INPUT BALANCE VALUE IS NULL OR LESS THAN 0');        
    WHEN EX_EMAIL_NULL THEN
        DBMS_OUTPUT.PUT_LINE('EMAIL FORMAT INCORRECT, TRY AGAIN');    
    WHEN DOES_NOT_EXIST THEN
        DBMS_OUTPUT.PUT_LINE('REGISTER CUSTOMER IN DATABSE');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ENTER VALID INPUTS');    
    ROLLBACK;
END ADD_BALANCE;
    
    PROCEDURE CURRENT_BALANCE(EMAIL IN CUSTOMER.EMAIL_ID%TYPE, O_BAL OUT WALLET.BALANCE%TYPE) AS
    VAL NUMBER;
    W_ID WALLET.WALLET_ID%TYPE;
    BAL WALLET.BALANCE%TYPE;
    USER_DOESNT_EXIST_EXCEP EXCEPTION;
    EMAIL_ISSUE EXCEPTION;

BEGIN
    EXECUTE IMMEDIATE ('SELECT COUNT(*) from (SELECT 1 from dual where REGEXP_LIKE ('''||EMAIL||''', ''^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$''))') INTO VAL;

    IF LENGTH(UPPER(EMAIL)) IS NULL OR VAL<1 THEN
        RAISE EMAIL_ISSUE;
    END IF;
    
    EXECUTE IMMEDIATE ('SELECT COUNT(*) FROM CUSTOMER WHERE UPPER(EMAIL_ID)=UPPER('''||EMAIL||''')') INTO VAL;

    IF VAL<1 THEN
        RAISE USER_DOESNT_EXIST_EXCEP;
    END IF;

    EXECUTE IMMEDIATE ('SELECT WALLET_ID FROM CUSTOMER WHERE EMAIL_ID='''||EMAIL||'''') INTO W_ID;
    EXECUTE IMMEDIATE ('SELECT BALANCE FROM WALLET WHERE WALLET_ID='||W_ID) INTO BAL;

    DBMS_OUTPUT.PUT_LINE('BALANCE FOR '||EMAIL||' IS '||BAL);
    O_BAL:=BAL;
    COMMIT;

    EXCEPTION
    WHEN EMAIL_ISSUE THEN
        DBMS_OUTPUT.PUT_LINE('EMAIL FORMAT INCORRECT, TRY AGAIN');
    WHEN USER_DOESNT_EXIST_EXCEP THEN
        DBMS_OUTPUT.PUT_LINE('USER DOES NOT EXIST, REGISTER FIRST AS NEW USER');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ENTER VALID INPUTS');    
    ROLLBACK;
END CURRENT_BALANCE;
    
    PROCEDURE CUSTOMER_REGISTRATION(F_NAME IN CUSTOMER.FIRST_NAME%TYPE,L_NAME IN CUSTOMER.LAST_NAME%TYPE, MOB_NO IN CUSTOMER.MOBILE_NUMBER%TYPE, EMAIL IN CUSTOMER.EMAIL_ID%TYPE) AS
    C_ID CUSTOMER.CUSTOMER_ID%TYPE;
    VAL CUSTOMER.CUSTOMER_ID%TYPE;
    VAL1 NUMBER;
    W_ID WALLET.WALLET_ID%TYPE;
    EX_FNAME_NULL EXCEPTION;
    EX_LNAME_NULL EXCEPTION;
    USER_EXISTS_EXCEP EXCEPTION;
    MOB_NO_FORMAT EXCEPTION;
    EMAIL_ISSUE EXCEPTION;
BEGIN
    EXECUTE IMMEDIATE ('SELECT COUNT(*) FROM CUSTOMER') INTO VAL;
    IF VAL=0 THEN
        C_ID:=10000;

    ELSIF VAL>0 THEN
        SELECT CUSTOMER_ID INTO C_ID FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT MAX(CUSTOMER_ID) FROM CUSTOMER);
        C_ID:=C_ID+1;
    END IF;

    IF LENGTH(UPPER(F_NAME)) IS NULL THEN
        RAISE EX_FNAME_NULL;
    END IF;

    IF LENGTH(UPPER(L_NAME)) IS NULL THEN
        RAISE EX_LNAME_NULL;
    END IF;

    IF MOB_NO < 1000000000 OR MOB_NO>9999999999 THEN
        RAISE MOB_NO_FORMAT;
    END IF;

    EXECUTE IMMEDIATE ('SELECT COUNT(*) from (SELECT 1 from dual where REGEXP_LIKE ('''||EMAIL||''', ''^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$''))') INTO VAL1;

    IF LENGTH(UPPER(EMAIL)) IS NULL OR VAL1<1 THEN
        RAISE EMAIL_ISSUE;
    END IF;

    EXECUTE IMMEDIATE ('SELECT COUNT(*) FROM CUSTOMER WHERE UPPER(EMAIL_ID)=UPPER('''||EMAIL||''')') INTO VAL1;

    IF VAL1>0 THEN
        RAISE USER_EXISTS_EXCEP;
    END IF;

    WALLET_REGISTRATION(W_ID);

    --DBMS_OUTPUT.PUT_LINE('INSERT INTO WALLET VALUES ('||W_ID||',0)');
    --DBMS_OUTPUT.PUT_LINE('INSERT INTO CUSTOMER VALUES ('||C_ID||','''||F_NAME||''','''||L_NAME||''','||MOB_NO||','''||EMAIL||''',0,'||W_ID||')');
    EXECUTE IMMEDIATE('INSERT INTO WALLET VALUES ('||W_ID||',0)');
    EXECUTE IMMEDIATE('INSERT INTO CUSTOMER VALUES ('||C_ID||','''||F_NAME||''','''||L_NAME||''','||MOB_NO||','''||EMAIL||''',NULL,NULL,'||W_ID||')');
    --INSERT INTO CUSTOMER VALUES (C_ID,F_NAME,L_NAME,MOB_NO,EMAIL,0,W_ID);

    COMMIT;

    EXCEPTION
    WHEN EX_FNAME_NULL THEN
        DBMS_OUTPUT.PUT_LINE('FIRST NAME CANNOT BE EMPTY');
    WHEN EX_LNAME_NULL THEN
        DBMS_OUTPUT.PUT_LINE('LAST NAME CANNOT BE EMPTY');
    WHEN USER_EXISTS_EXCEP THEN
        DBMS_OUTPUT.PUT_LINE('USER ALREADY EXISTS, CANNOT BE REGISTERED AS NEW USER');
    WHEN MOB_NO_FORMAT THEN
        DBMS_OUTPUT.PUT_LINE('MOBILE NUMBER CANNOT BE NEGATIVE OR GREATER THAN 10 DIGITS');
    WHEN EMAIL_ISSUE THEN
        DBMS_OUTPUT.PUT_LINE('PLEASE ENTER EMAIL IN VALID FORMAT');
   -- WHEN OTHERS THEN
     --   DBMS_OUTPUT.PUT_LINE('ENTER VALID INPUTS');
    ROLLBACK;
END CUSTOMER_REGISTRATION;
    
    PROCEDURE END_RIDE(EMAIL IN CUSTOMER.EMAIL_ID%TYPE, D_ID IN BIKE.DOCK_ID%TYPE,C_NAME IN DISCOUNT.COUPON_NAME%TYPE) AS
    END_TIME DATE := CURRENT_DATE;
    START_TIME DATE;
    CUST_ID CUSTOMER.CUSTOMER_ID%TYPE;
    DISCOUNT_AMT DISCOUNT.COUPON_VALUE%TYPE;
    TOTAL_TIME NUMBER;
    MEM_ID MEMBERSHIP.MEMBERSHIP_ID%TYPE := 0;
    WAL_ID CUSTOMER.WALLET_ID%TYPE;
    BAL WALLET.BALANCE%TYPE;
    B_ID BIKE.BIKE_ID%TYPE;
    GRAND_TOTAL NUMBER;
    R_ID RENT.RENT_ID%TYPE;
    CHECK_WRONG_DATA BOOLEAN := TRUE;
    C_ID DISCOUNT.COUPON_ID%TYPE;
    DOC_ID_CHECK NUMBER;
    D_ID_WRONG EXCEPTION;
    EMAIL_NULL EXCEPTION;
    D_ID_NULL EXCEPTION;

BEGIN

    IF D_ID IS NULL THEN
        RAISE D_ID_NULL;
    END IF;

    IF EMAIL IS NULL THEN
        RAISE EMAIL_NULL;
    END IF;
    
    BEGIN
        SELECT CUSTOMER_ID INTO CUST_ID FROM CUSTOMER WHERE EMAIL_ID = UPPER(EMAIL);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ENTERED EMAIL IS WRONG');
            CHECK_WRONG_DATA := FALSE;
        ROLLBACK;
    END;

    IF CHECK_WRONG_DATA THEN
        BEGIN
            SELECT RENT_ID INTO R_ID FROM RENT WHERE DROP_TIME IS NULL AND PAYMENT_STATUS IS NULL AND CUSTOMER_ID = CUST_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('NO RIDE TO END');
                CHECK_WRONG_DATA := FALSE;
            ROLLBACK;
        END;
    END IF;

    IF CHECK_WRONG_DATA THEN
        BEGIN
            SELECT MEMBERSHIP_ID INTO MEM_ID FROM CUSTOMER WHERE CUSTOMER_ID = CUST_ID AND MEMBERSHIP_END_DATE > CURRENT_DATE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                MEM_ID := 0;
                CHECK_WRONG_DATA := FALSE;
            ROLLBACK;
        END;
    END IF;

    IF CHECK_WRONG_DATA THEN
        IF C_NAME IS NOT NULL THEN
            BEGIN
                SELECT COUPON_ID INTO C_ID FROM DISCOUNT WHERE COUPON_NAME = C_NAME;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('COUPON NAME DOES NOT EXIST');
                    CHECK_WRONG_DATA := FALSE;
                ROLLBACK;
            END;
        END IF;
    END IF;

    IF CHECK_WRONG_DATA THEN
        IF C_NAME IS NOT NULL THEN        
            BEGIN
                SELECT COUPON_VALUE INTO DISCOUNT_AMT FROM DISCOUNT WHERE COUPON_NAME = C_NAME AND COUPON_STATUS = 'ACTIVE';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('COUPON HAS EXPIRED');
                    CHECK_WRONG_DATA := FALSE;
                ROLLBACK;
            END;

        END IF;
    END IF;

    IF CHECK_WRONG_DATA THEN
        SELECT COUNT(*) INTO DOC_ID_CHECK FROM DOCK WHERE DOCK_ID = D_ID;
        IF DOC_ID_CHECK = 0 THEN
            RAISE D_ID_WRONG;
        END IF;
        SELECT BIKE_ID INTO B_ID FROM RENT WHERE RENT_ID = R_ID;
        SELECT PICKUP_TIME INTO START_TIME FROM RENT WHERE RENT_ID = R_ID;
        SELECT (END_TIME - START_TIME)* 24 * 60 difference_in_minutes INTO TOTAL_TIME FROM DUAL;
        IF MEM_ID = 1 THEN
            GRAND_TOTAL := (TOTAL_TIME * 10)/60 - (10/6000)*(TOTAL_TIME * 10);
        ELSIF MEM_ID = 2 THEN
            GRAND_TOTAL := (TOTAL_TIME * 10)/60 - (20/6000)*(TOTAL_TIME * 10);
        ELSIF MEM_ID = 3 THEN
            GRAND_TOTAL := (TOTAL_TIME * 10)/60 - (30/6000)*(TOTAL_TIME * 10);
        ELSE
            GRAND_TOTAL := (TOTAL_TIME * 10)/60;
        END IF;

        GRAND_TOTAL := GRAND_TOTAL - (DISCOUNT_AMT/100)*GRAND_TOTAL;

        SELECT WALLET_ID INTO WAL_ID FROM CUSTOMER WHERE CUSTOMER_ID = CUST_ID;
        BAL := WALLET_BALANCE(WAL_ID);

        IF BAL > GRAND_TOTAL THEN
            UPDATE WALLET SET BALANCE = BALANCE - GRAND_TOTAL WHERE WALLET_ID = WAL_ID;
            UPDATE RENT SET PAYMENT_STATUS = 'PAID' WHERE RENT_ID = R_ID;
            UPDATE BIKE SET BIKE_STATUS = 'AVAILABLE' WHERE BIKE_ID = B_ID;
            UPDATE BIKE SET DOCK_ID = D_ID WHERE BIKE_ID = B_ID;
            UPDATE RENT SET COUPON_ID = C_ID WHERE RENT_ID = R_ID;
            UPDATE RENT SET DROP_TIME = END_TIME WHERE RENT_ID = R_ID;
            DBMS_OUTPUT.PUT_LINE('YOU HAVE ENDED YOUR RIDE SUCCESSFULLY');
        ELSE
            UPDATE BIKE SET BIKE_STATUS = 'AVAILABLE' WHERE BIKE_ID = B_ID;
            UPDATE BIKE SET DOCK_ID = D_ID WHERE BIKE_ID = B_ID;
            UPDATE RENT SET PAYMENT_STATUS = 'UNPAID' WHERE RENT_ID = R_ID;
            UPDATE RENT SET COUPON_ID = C_ID WHERE RENT_ID = R_ID;
            UPDATE RENT SET DROP_TIME = END_TIME WHERE RENT_ID = R_ID;
            DBMS_OUTPUT.PUT_LINE('INSUFFICIENT BALANCE IN YOUR WALLET. REFILL YOUR WALLET');
            DBMS_OUTPUT.PUT_LINE('TO ADD BALANCE EXECUTE ADD_BALANCE(''EMAIL_ID'',  NEW_BAL )');
        END IF;

        COMMIT;
    END IF;

    EXCEPTION 
        WHEN D_ID_NULL THEN
            DBMS_OUTPUT.PUT_LINE('DOCK ID CANNOT BE NULL');
        WHEN EMAIL_NULL THEN
            DBMS_OUTPUT.PUT_LINE('EMAIL ID CANNOT BE NULL');
        WHEN D_ID_WRONG THEN
            DBMS_OUTPUT.PUT_LINE('ENTERED DOCK ID IS INCORRECT');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);    

    ROLLBACK;

END END_RIDE;
    
    PROCEDURE MAKE_PAYMENT(EMAIL IN CUSTOMER.EMAIL_ID%TYPE) AS
    CUST_ID CUSTOMER.CUSTOMER_ID%TYPE;
    MEM_ID MEMBERSHIP.MEMBERSHIP_ID%TYPE;
    R_ID RENT.RENT_ID%TYPE;
    DISCOUNT_AMT DISCOUNT.COUPON_VALUE%TYPE;
    CHECK_WRONG_DATA BOOLEAN := TRUE;
    END_TIME DATE;
    START_TIME DATE;
    TOTAL_TIME NUMBER;
    BAL WALLET.BALANCE%TYPE;
    WAL_ID CUSTOMER.WALLET_ID%TYPE;
    GRAND_TOTAL NUMBER;
    EMAIL_NULL EXCEPTION;
BEGIN
    IF EMAIL IS NULL THEN
        RAISE EMAIL_NULL;
    END IF;

    BEGIN
        SELECT CUSTOMER_ID INTO CUST_ID FROM CUSTOMER WHERE EMAIL_ID = UPPER(EMAIL);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ENTERED EMAIL IS WRONG');
            CHECK_WRONG_DATA := FALSE;
        ROLLBACK;
    END;

    IF CHECK_WRONG_DATA THEN
        BEGIN
            SELECT RENT_ID INTO R_ID FROM RENT WHERE CUSTOMER_ID = CUST_ID AND PAYMENT_STATUS = 'UNPAID';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('NO PENDING PAYMENTS');
                CHECK_WRONG_DATA := FALSE;
            ROLLBACK;
        END;
    END IF;

    IF CHECK_WRONG_DATA THEN
        BEGIN
            SELECT MEMBERSHIP_ID INTO MEM_ID FROM CUSTOMER WHERE CUSTOMER_ID = CUST_ID AND MEMBERSHIP_END_DATE > CURRENT_DATE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                MEM_ID := 0;
                CHECK_WRONG_DATA := FALSE;
            ROLLBACK;
        END;
    END IF;
    IF CHECK_WRONG_DATA THEN
        SELECT COUPON_VALUE INTO DISCOUNT_AMT 
        FROM DISCOUNT D
        LEFT JOIN RENT R ON D.COUPON_ID = R.COUPON_ID
        WHERE CUSTOMER_ID = CUST_ID AND PAYMENT_STATUS = 'UNPAID';
        SELECT PICKUP_TIME INTO START_TIME FROM RENT WHERE RENT_ID = R_ID;
        SELECT DROP_TIME INTO END_TIME FROM RENT WHERE RENT_ID = R_ID;
        SELECT (END_TIME - START_TIME)* 24 * 60 difference_in_minutes INTO TOTAL_TIME FROM DUAL;

        IF MEM_ID = 1 THEN
            GRAND_TOTAL := (TOTAL_TIME * 10)/60 - (10/6000)*(TOTAL_TIME * 10);
        ELSIF MEM_ID = 2 THEN
            GRAND_TOTAL := (TOTAL_TIME * 10)/60 - (20/6000)*(TOTAL_TIME * 10);
        ELSIF MEM_ID = 3 THEN
            GRAND_TOTAL := (TOTAL_TIME * 10)/60 - (30/6000)*(TOTAL_TIME * 10);
        ELSE
            GRAND_TOTAL := (TOTAL_TIME * 10)/60;
        END IF;


        GRAND_TOTAL := GRAND_TOTAL - (DISCOUNT_AMT/100)*GRAND_TOTAL;

        SELECT WALLET_ID INTO WAL_ID FROM CUSTOMER WHERE CUSTOMER_ID = CUST_ID;
        BAL := WALLET_BALANCE(WAL_ID);

        IF BAL > GRAND_TOTAL THEN
            UPDATE WALLET SET BALANCE = BALANCE - GRAND_TOTAL WHERE WALLET_ID = WAL_ID;
            UPDATE RENT SET PAYMENT_STATUS = 'PAID' WHERE RENT_ID = R_ID;
            DBMS_OUTPUT.PUT_LINE('THANK YOU FOR THE PAYMENT');
        ELSE
            DBMS_OUTPUT.PUT_LINE('INSUFFICIENT BALANCE IN YOUR WALLET. REFILL YOUR WALLET');
            DBMS_OUTPUT.PUT_LINE('TO ADD BALANCE EXECUTE ADD_BALANCE(''EMAIL_ID'',  NEW_BAL )');
        END IF;

        COMMIT;
    END IF;
EXCEPTION
    WHEN EMAIL_NULL THEN
        DBMS_OUTPUT.PUT_LINE('EMAIL ID CANNOT BE NULL');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;
END MAKE_PAYMENT;

    PROCEDURE PRINT_ISSUE_OPTIONS IS
BEGIN
   DBMS_OUTPUT.PUT_LINE('CHOOSE THE ISSUE TYPE YOU ARE FACING');
   DBMS_OUTPUT.PUT_LINE('1. REGISTRATION ISSUE');
   DBMS_OUTPUT.PUT_LINE('2. WALLET SETUP');
   DBMS_OUTPUT.PUT_LINE('3. PAYMENT DEDUCTION ISSUE');
   DBMS_OUTPUT.PUT_LINE('4. BOOKING ISSUE');
   DBMS_OUTPUT.PUT_LINE('5. COUPON ISSUE');
   DBMS_OUTPUT.PUT_LINE('6. DISCOUNT USAGE ISSUE');
   DBMS_OUTPUT.PUT_LINE('7. BIKE AVAILABILITY ISSUE');
   DBMS_OUTPUT.PUT_LINE('8. BIKE CONDITION ISSUE');
   DBMS_OUTPUT.PUT_LINE('9. MEMBERSHIP RENEWAL ISSUES');
   DBMS_OUTPUT.PUT_LINE('10. OTHER ISSUES');
   DBMS_OUTPUT.PUT_LINE('TO GET CUSTOMER CARE EXECUTE TICKET_CREATION(''EMAIL_ID'',''ISSUE_TYPE_DESCRIPTION'')');
END PRINT_ISSUE_OPTIONS;

    PROCEDURE PRINT_MEMBERSHIP_OPTIONS IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(' ');
  FOR i in (SELECT * FROM MEMBERSHIP ORDER BY MEMBERSHIP_ID) LOOP
    dbms_output.put_line('     ' || i.MEMBERSHIP_ID || ' ' || i.MEMBERSHIP_TYPE || ' ' || i.MEMBERSHIP_AMOUNT);
  END LOOP; 
  DBMS_OUTPUT.PUT_LINE('TO BUY MEMBERSHIP EXECUTE MEMBERSHIP_REGISTER_CHOICE(''REGISTERED_EMAIL'',MEMBERSHIP_ID);');
END PRINT_MEMBERSHIP_OPTIONS;
    
    PROCEDURE START_RIDE(B_ID IN BIKE.BIKE_ID%TYPE, EMAIL IN CUSTOMER.EMAIL_ID%TYPE) AS
    CUST_ID CUSTOMER.CUSTOMER_ID%TYPE := NULL;
    BI_ID BIKE.BIKE_ID%TYPE := NULL;
    P_STATUS RENT.PAYMENT_STATUS%TYPE;
    CHECK_WRONG_DATA BOOLEAN := TRUE;
    COUNTER NUMBER := 0;
    EMAIL_NULL EXCEPTION;
    EMAIL_WRONG EXCEPTION;
    B_ID_NULL EXCEPTION;
    B_ID_WRONG EXCEPTION;
    B_ID_UNAVAILABLE EXCEPTION;
    P_STATUS_UNPAID EXCEPTION;
    ON_GOING_RIDE EXCEPTION;
    VAL NUMBER;
    MDATE DATE;
BEGIN

    IF B_ID IS NULL THEN
        RAISE B_ID_NULL;
    END IF;

    IF EMAIL IS NULL THEN
        RAISE EMAIL_NULL;
    END IF;

    BEGIN
        SELECT CUSTOMER_ID INTO CUST_ID FROM CUSTOMER WHERE EMAIL_ID = UPPER(EMAIL);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ENTERED EMAIL IS WRONG');
            CHECK_WRONG_DATA := FALSE;
        ROLLBACK;
    END;

    BEGIN
        SELECT BIKE_ID INTO BI_ID FROM BIKE WHERE BIKE_ID = B_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ENTERED BIKE ID IS WRONG');
            CHECK_WRONG_DATA := FALSE;
        ROLLBACK;
    END;

    BEGIN
        SELECT BIKE_ID INTO BI_ID FROM BIKE WHERE BIKE_STATUS = 'AVAILABLE' AND BIKE_ID = B_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('SELECTED BIKE IS NOT AVAILABLE');
            CHECK_WRONG_DATA := FALSE;
        ROLLBACK;
    END;

    IF CHECK_WRONG_DATA THEN
        SELECT COUNT(*) INTO COUNTER FROM RENT WHERE CUSTOMER_ID = CUST_ID AND PAYMENT_STATUS = 'UNPAID';
        IF COUNTER > 0 THEN
            RAISE P_STATUS_UNPAID;
        END IF;
        SELECT COUNT(*) INTO COUNTER FROM RENT WHERE CUSTOMER_ID = CUST_ID AND PAYMENT_STATUS IS NULL;
        IF COUNTER > 0 THEN
            RAISE ON_GOING_RIDE;
        END IF;
        SELECT MEMBERSHIP_ID, MEMBERSHIP_END_DATE INTO VAL, MDATE FROM CUSTOMER WHERE CUSTOMER_ID = CUST_ID;
        IF VAL IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('BUY MEMBERSHIP TO ENJOY BENEFITS!');
        ELSIF VAL>0 AND MDATE<CURRENT_DATE THEN
        DBMS_OUTPUT.PUT_LINE('RENEW MEMBERSHIP TO CONTINUE ENJOYING BENEFITS!');
        END IF;
        INSERT INTO RENT VALUES(RENT_ID_SEQUENCE.NEXTVAL, CURRENT_DATE, NULL, B_ID, CUST_ID, NULL, NULL);
        UPDATE BIKE SET BIKE_STATUS = 'UNAVAILABLE' WHERE BIKE_ID = B_ID; --CAN BE HANDLED WITH TRIGGER
        DBMS_OUTPUT.PUT_LINE('RIDE STARTED');
        COMMIT;
    END IF;

    EXCEPTION
        WHEN B_ID_NULL THEN
            DBMS_OUTPUT.PUT_LINE('BIKE ID CANNOT BE NULL');
        WHEN EMAIL_NULL THEN
            DBMS_OUTPUT.PUT_LINE('EMAIL ID CANNOT BE NULL');
        WHEN P_STATUS_UNPAID THEN
            DBMS_OUTPUT.PUT_LINE('YOU HAVE AN UNPAID TRANSACTION. CLEAR DUES TO BOOK NEW RIDE');
        WHEN ON_GOING_RIDE THEN
            DBMS_OUTPUT.PUT_LINE('RIDE IS STILL ON. FINISH THAT AND START NEW');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
END START_RIDE;
    
    PROCEDURE TICKET_CREATION(EMAIL IN CUSTOMER.EMAIL_ID%TYPE, T_TYPE IN TICKETING_QUEUE.TICKET_DESC%TYPE) AS 
EX_EMAIL_NULL EXCEPTION;
USER_DOESNT_EXIST_EXCEP EXCEPTION;
T_TYPE_ISSUE EXCEPTION;
CUSTOMER_CARE_EXCEP EXCEPTION;
VAL NUMBER;
E_ID CUSTOMER_TECHNICIAN_STATE.EMPLOYEE_ID%TYPE;
TIC_ID TICKETING_QUEUE.TICKET_ID%TYPE;

BEGIN
    EXECUTE IMMEDIATE ('SELECT COUNT(*) from (SELECT 1 from dual where REGEXP_LIKE ('''||EMAIL||''', ''^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$''))') INTO VAL;

    IF LENGTH(UPPER(EMAIL)) IS NULL OR VAL<1 THEN
        RAISE EX_EMAIL_NULL;
    END IF;

    EXECUTE IMMEDIATE ('SELECT COUNT(*) FROM CUSTOMER WHERE UPPER(EMAIL_ID)=UPPER('''||EMAIL||''')') INTO VAL;

    IF VAL<1 THEN
        RAISE USER_DOESNT_EXIST_EXCEP;
    END IF;


    IF LENGTH(UPPER(T_TYPE)) IS NULL OR(UPPER(T_TYPE)!='REGISTRATION ISSUE' AND 
                                        UPPER(T_TYPE)!='WALLET SETUP' AND 
                                        UPPER(T_TYPE)!='PAYMENT DEDUCTION ISSUE' AND 
                                        UPPER(T_TYPE)!='BOOKING ISSUE' AND 
                                        UPPER(T_TYPE)!='COUPON ISSUE' AND 
                                        UPPER(T_TYPE)!='DISCOUNT USAGE ISSUE' AND 
                                        UPPER(T_TYPE)!='BIKE AVAILABILITY ISSUE' AND 
                                        UPPER(T_TYPE)!='BIKE CONDITION ISSUE' AND 
                                        UPPER(T_TYPE)!='MEMBERSHIP RENEWAL ISSUES' AND 
                                        UPPER(T_TYPE)!='OTHER ISSUES')THEN
        RAISE T_TYPE_ISSUE;
    END IF;

    EXECUTE IMMEDIATE ('SELECT COUNT(*) FROM CUSTOMER_TECHNICIAN_STATE WHERE CUSTOMER_TECHNICIAN_STATUS=''AVAILABLE''') INTO VAL;

    IF VAL<1 THEN
        RAISE CUSTOMER_CARE_EXCEP;
    END IF;    

    SELECT EMPLOYEE_ID INTO E_ID FROM CUSTOMER_TECHNICIAN_STATE WHERE EMPLOYEE_ID=(SELECT MIN(EMPLOYEE_ID) FROM CUSTOMER_TECHNICIAN_STATE WHERE CUSTOMER_TECHNICIAN_STATUS='AVAILABLE');

    UPDATE CUSTOMER_TECHNICIAN_STATE SET CUSTOMER_TECHNICIAN_STATUS='UNAVAILABLE' WHERE EMPLOYEE_ID=E_ID;

    EXECUTE IMMEDIATE ('SELECT COUNT(*) FROM TICKETING_QUEUE') INTO VAL;
    IF VAL=0 THEN
        TIC_ID:=100000000;
    ELSIF VAL>0 THEN
        SELECT TICKET_ID INTO TIC_ID FROM TICKETING_QUEUE WHERE TICKET_ID=(SELECT MAX(TICKET_ID) FROM TICKETING_QUEUE);
        TIC_ID:=TIC_ID+1;
    END IF;  


    INSERT INTO TICKETING_QUEUE VALUES (TIC_ID,(SELECT CUSTOMER_ID FROM CUSTOMER WHERE UPPER(EMAIL_ID)=UPPER(EMAIL)),E_ID,T_TYPE,'ASSIGNED');

    DBMS_OUTPUT.PUT_LINE('TICKET ASSIGNED');
    COMMIT;

EXCEPTION
    WHEN EX_EMAIL_NULL THEN
        DBMS_OUTPUT.PUT_LINE('EMAIL ID FORMAT IS INCORRECT, TRY AGAIN');
     when USER_DOESNT_EXIST_EXCEP then
            dbms_output.put_line('CUSTOMER DOES NOT EXIST, REGISTER FIRST');
    WHEN T_TYPE_ISSUE THEN
        DBMS_OUTPUT.PUT_LINE('PRINT ISSUE OPTIONS AGAIN AND ENTER THE CORRECT TICKET TYPE DESCRIPTION');
    WHEN CUSTOMER_CARE_EXCEP THEN
        DBMS_OUTPUT.PUT_LINE('CUSTOMER TECHNICIAN NOT AVAILABLE, TRY AGAIN SOON');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;
END TICKET_CREATION;
    
    PROCEDURE UPDATE_CUSTOMER_DETAILS(EMAIL IN CUSTOMER.EMAIL_ID%TYPE, ISS_TYPE IN VARCHAR, ISS_VALUE IN VARCHAR) AS 
    VAL NUMBER;
    BAL WALLET.BALANCE%TYPE;
    DOES_NOT_EXIST EXCEPTION;
    EX_EMAIL_NULL EXCEPTION;
    USER_EXISTS_EXCEP EXCEPTION;
    BAL_NULL EXCEPTION;
    ISS_TYPE_ISSUE EXCEPTION;
    EMAIL_UPD_EXC EXCEPTION;
    F_NAME_FORMAT EXCEPTION;
    L_NAME_FORMAT EXCEPTION;
    MOBNO_INCORRECT_FORMAT EXCEPTION;

BEGIN
    EXECUTE IMMEDIATE ('SELECT COUNT(*) from (SELECT 1 from dual where REGEXP_LIKE ('''||EMAIL||''', ''^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$''))') INTO VAL;

    IF LENGTH(UPPER(EMAIL)) IS NULL OR VAL<1 THEN
        RAISE EX_EMAIL_NULL;
    END IF;

    EXECUTE IMMEDIATE ('SELECT COUNT(*) FROM (SELECT WALLET_ID FROM CUSTOMER WHERE UPPER(EMAIL_ID)=UPPER('''||EMAIL||'''))') INTO VAL;

    IF VAL=0 THEN
        RAISE DOES_NOT_EXIST;
    END IF;

    IF LENGTH(UPPER(ISS_TYPE)) IS NULL OR(UPPER(ISS_TYPE)!='FIRST NAME' AND 
                                        UPPER(ISS_TYPE)!='LAST NAME' AND 
                                        UPPER(ISS_TYPE)!='MOBILE NUMBER' AND 
                                        UPPER(ISS_TYPE)!='EMAIL ID')THEN
        RAISE ISS_TYPE_ISSUE;
    END IF;

    IF ISS_TYPE = 'EMAIL ID' THEN
        RAISE EMAIL_UPD_EXC;
    END IF;

    IF ISS_TYPE = 'MOBILE NUMBER' THEN
        IF LENGTH(ISS_VALUE)=10 AND (TO_NUMBER(ISS_VALUE)>= 1000000000 OR TO_NUMBER(ISS_VALUE)<=9999999999) THEN
            UPDATE CUSTOMER SET MOBILE_NUMBER=TO_NUMBER(ISS_VALUE) WHERE UPPER(EMAIL_ID)=UPPER(EMAIL);
        ELSE
            RAISE MOBNO_INCORRECT_FORMAT;
        END IF;
    END IF;

    IF ISS_TYPE = 'FIRST NAME' THEN
        IF ISS_VALUE IS NULL THEN
            RAISE F_NAME_FORMAT;
        ELSE
            UPDATE CUSTOMER SET FIRST_NAME=ISS_VALUE WHERE UPPER(EMAIL_ID)=UPPER(EMAIL);
        END IF;
    END IF;

    IF ISS_TYPE = 'LAST NAME' THEN
        IF ISS_VALUE IS NULL THEN
            RAISE L_NAME_FORMAT;
        ELSE
            UPDATE CUSTOMER SET LAST_NAME=ISS_VALUE WHERE UPPER(EMAIL_ID)=UPPER(EMAIL);
        END IF;
    END IF;

    COMMIT;

    EXCEPTION
    WHEN F_NAME_FORMAT THEN
        DBMS_OUTPUT.PUT_LINE('FIRST NAME CANNOT BE EMPTY');
    WHEN L_NAME_FORMAT THEN
        DBMS_OUTPUT.PUT_LINE('LAST NAME CANNOT BE EMPTY');
    WHEN MOBNO_INCORRECT_FORMAT THEN
        DBMS_OUTPUT.PUT_LINE('MOBILE NUMBER CANNOT BE NEGATIVE OR GREATER THAN 10 DIGITS');
    WHEN EMAIL_UPD_EXC THEN
        DBMS_OUTPUT.PUT_LINE('EMAIL CANNOT BE UPDATED');
    WHEN ISS_TYPE_ISSUE THEN
        DBMS_OUTPUT.PUT_LINE('PLEASE ENTER VALID ISSUE TYPES');
    WHEN DOES_NOT_EXIST  THEN
        DBMS_OUTPUT.PUT_LINE('USER DOES NOT EXIST');
    WHEN EX_EMAIL_NULL  THEN
        DBMS_OUTPUT.PUT_LINE('EMAIL CANNOT BE NULL');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('ENTER VALID INPUTS');
    ROLLBACK;
END UPDATE_CUSTOMER_DETAILS;

    PROCEDURE UPDATE_CUSTOMER_OPTIONS IS
BEGIN
   DBMS_OUTPUT.PUT_LINE('CHOOSE THE CUSTOMER DETAILS YOU WISH TO ALTER');
   DBMS_OUTPUT.PUT_LINE('1. FIRST NAME');
   DBMS_OUTPUT.PUT_LINE('2. LAST NAME');
   DBMS_OUTPUT.PUT_LINE('3. MOBILE NUMBER');
   DBMS_OUTPUT.PUT_LINE('4. EMAIL ID');
   DBMS_OUTPUT.PUT_LINE('TO GET CUSTOMER CARE EXECUTE UPDATE_CUSTOMER_DETAILS(''EMAIL_ID'',''UPDATE_DETAIL_DESCRIPTION'')');
END UPDATE_CUSTOMER_OPTIONS;

END CUSTOMER_ACTIONS;
/

CREATE OR REPLACE PUBLIC SYNONYM CUSTOMER_ACTIONS for NAGPALM.CUSTOMER_ACTIONS;
