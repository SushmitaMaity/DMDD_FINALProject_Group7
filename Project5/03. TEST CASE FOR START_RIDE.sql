--TEST CASES
--NULL BIKE
EXECUTE START_RIDE(NULL,'LOIS.WALKER@HOTMAIL.COM');

--WRONG BIKE
EXECUTE START_RIDE(1,'LOIS.WALKER@HOTMAIL.COM');

--WRONG EMAIL
EXECUTE START_RIDE(1000,'LOIS.WALKERHOTMAIL.COM');

--NULL EMAIL
EXECUTE START_RIDE(1000,'');

--BIKE UNAVAILABLE BIKE
EXECUTE START_RIDE(1006,'LOIS.WALKER@HOTMAIL.COM');

--PAST UNPAID TRANSACTIONS
EXECUTE START_RIDE(1000,'DIANE.EVANS@YAHOO.COM');

--BOOKING SUCCESSFUL
EXECUTE START_RIDE(1000,'LOIS.WALKER@HOTMAIL.COM');
