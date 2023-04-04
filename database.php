<!--Test Oracle file for UBC CPSC304 2018 Winter Term 1
  Created by Jiemin Zhang
  Modified by Simona Radu
  Modified by Jessica Wong (2018-06-22)
  This file shows the very basics of how to execute PHP commands
  on Oracle.
  Specifically, it will drop a table, create a table, insert values
  update values, and then query for values

  IF YOU HAVE A TABLE CALLED "demoTable" IT WILL BE DESTROYED

  The script assumes you already have a server set up
  All OCI commands are commands to the Oracle libraries
  To get the file to work, you must place it somewhere where your
  Apache server can run it, and you must rename it to have a ".php"
  extension.  You must also change the username and password on the
  OCILogon below to be your ORACLE username and password -->

<html>

<head>
    <title>CPSC 304 PHP/Steam Database</title>
</head>

<body>
    <h2>Show User Info</h2>
    <p>If this is the first time you're running this page, please click the button below to see our default user data.</p>

    <form method="POST" action="database.php">
        <input type="hidden" id="initializeTablesRequest" name="initializeTablesRequest">
        <p><input type="submit" value="Initialize" name="initializeSubmit"></p>
    </form>

    <hr />

    <!-- <h2>INSERT Query</h2> -->
    <h2> Insert a new user</h2>
    <form method="POST" action="database.php"> <!--refresh page when submitted-->
        <input type="hidden" id="insertQueryRequest" name="insertQueryRequest">
        ID: <input type="number" name="UserID"> <br /><br /> <!--number input-->
        Location: <input type="text" name="UserLocation"> <br /><br />
        Phone Number: <input type="tel" id="phone" name="phone" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}" required>
        <small>Format: 123-456-7890</small> <br /><br />
        User name: <input type="text" name="User_name"> <br /><br />
        <input type="submit" value="Insert" name="insertSubmit"></p>
    </form>

    <hr />

    <!-- <h2>DELETE Query</h2> -->
    <h2>Delete a User</h2>
    <form method="POST" action="database.php"> <!--refresh page when submitted-->
        <input type="hidden" id="deleteQueryRequest" name="deleteQueryRequest">
        User ID : <input type="number" name="deleteUserID"> <br /><br />
        <input type="submit" value="Delete" name="deleteSubmit"></p>
    </form>
    <hr />

    <!--Changed interpretation showing on the webpage-->
    <!-- <h2>UPDATE Query</h2> -->
    <h2>Update user location</h2>
    <p>Please first provide your user ID, and then enter your new user name, new location or phone number. Please note that you cannot update your profile URL, creation date, account level, playtime, and user id. Please leave the entry box blank if you don't want to update that value. </p>
    <p>The values are case sensitive and if you enter in the wrong case, the update statement will not do anything.</p>

    <form method="POST" action="database.php"> <!--refresh page when submitted-->
        <input type="hidden" id="updateQueryRequest" name="updateQueryRequest">
        UserID: <input type="number" name="userID"> <br /><br />
        New User Name: <input type="text" name="User_name"> <br /><br />
        New Location: <input type="text" name="newLoc"> <br /><br />
        New Phone Number: <input type="tel" id="phone" name="phone" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}">
        <small>Format: 123-456-7890</small> <br /><br />
        <input type="submit" value="Update" name="updateSubmit"></p>
    </form>

    <hr />

    <h2>SELECTION Query</h2>
    <h3>Find all the games below a specific price or released before a specific date</h3>
    <form method="GET" action="oracle-test1.php">
        <input type="hidden" id="SelectionQueryRequest" name="SelectionQueryRequest" value="selectionQueryRequest">
        <input type="checkbox" id="Price" name="attri[]" value="Price">
        Price: <input type="number" for="Price" step="0.001" name="PriceInput"><br>
        <input type="checkbox" id="Release_Date" name="attri[]" value="Release_Date">
        Release Date (Fromat: 02-FEB-2023): <input type="text" for="Release_Date" id="releaseDateInput" name="releaseDateInput"><br>
        <input type="submit" value="Select" name="selectionSubmit">
    </form>
    <hr />

    <!-- <h2>PROJECTION Query</h3> -->
    <h2>Choose Attributes to View:</h2>
    <form method="GET" action="database.php"> <!--refresh page when submitted-->
        <input type="hidden" id="projectQueryRequest" name="projectQueryRequest">
        <label>Select a relation:</label>
        <select name="projectTable">
            <option value='UserProfile'>User Profile</option>
            <option value='UserInfo'>User Info</option>
            <option value='FriendOf'>Friends</option>
            <option value='SupportTicketStatus'>SupportTicketStatus</option>
            <option value='SupportTicketRequest'>SupportTicketRequest</option>
            <option value='CompanyRevenue'>CompanyRevenue</option>
            <option value='CompanyInfo'>CompanyInfo</option>
            <option value='Publisher'>Publisher</option>
            <option value='Developer'>Developer</option>
            <option value='GamePrice'>GamePrice</option>
            <option value='GameURL'>GameURL</option>
            <option value='GameInfo'>GameInfo</option>
            <option value='own'>Own</option>
            <option value='GenreUpdate'>GenreUpdate</option>
            <option value='GenreName'>GameName</option>
            <option value='GenreDescription'>GenreDescription</option>
            <option value='BelongsTo'>BelongsTo</option>
            <option value='ReviewWriteAssociateUser'>ReviewWriteAssociateUser</option>
            <option value='ReviewWriteAssociateContent'>ReviewWriteAssociateContent</option>
            <option value='CommunityAssociate'>CommunityAssociate</option>
            <option value='Participate'>Participate</option>
            <option value='SalesEventDate'>SalesEventDate</option>
            <option value='SalesEventContent'>SalesEventContent</option>
            <option value='DiscountAssociate'>DiscountAssociate</option>
        </select>
        <p>Select one table, click submit, fill in checkboxes and make sure choose the desired table again.</p>
        <br><br>
        <label>Select attributes:</label><br>
        <?php
        // retrieve the selected table from the GET request
        $tableName = $_GET['projectTable'];

        // create an array of attributes for each table
        $attributes = array(
            'UserProfile' => array('Profile_URL', 'User_name', 'Creation_Date', 'Account_Level'),
            'UserInfo' => array('Playtime', 'UserID', 'UserLocation', 'PhoneNum', 'Profile_URL'),
            'FriendOf' => array('UserID', 'FUID'),
            'SupportTicketStatus' => array('Description', 'Date_reported', 'UserID', 'Status'),
            'SupportTicketRequest' => array('TID', 'Description', 'Date_reported', 'UserID'),
            'CompanyRevenue' => array('Name', 'Location', 'Revenue'),
            'CompanyInfo' => array('CID', 'Email', 'Name', 'Location'),
            'Publisher' => array('CPID', 'NumGamePublished'),
            'Developer' => array('CDID', 'NumGameDeveloped'),
            'GamePrice' => array('Name', 'Release_Date', 'Price'),
            'GameURL' => array('URL', 'Name', 'Requirements', 'num_of_internal_achievement'),
            'GameInfo' => array('GID', 'URL', 'gameDescription', 'CPID', 'CDID'),
            'Own' => array('UserID', 'GID', 'ownDate', 'Ownership_type'),
            'GenreUpdate' => array('Name', 'LastUpdatedDate'),
            'GenreName' => array('Description', 'name'),
            'GenreDescription' => array('GeID', 'Description'),
            'BelongsTo' => array('GID', 'GeID'),
            'ReviewWriteAssociateUser' => array('ReviewText', 'Rating', 'PostDate', 'UserID'),
            'ReviewWriteAssociateContent' => array('RID', 'GID', 'ReviewText', 'PostDate'),
            'CommunityAssociate' => array('CoID', 'GID', 'Title', 'Section'),
            'Participate' => array('CoID', 'UserID'),
            'SalesEventDate' => array('SalesDescription', 'StartDate'),
            'SalesDescription' => array('SID', 'SalesDescription', 'CID'),
            'DiscountAssociate' => array('GID', 'SID', 'DiscountPercentage')
        );

        foreach ($attributes[$tableName] as $attribute) {
            echo "<label><input type='checkbox' name='projectAttributes[]' value='$attribute'> $attribute </label><br>";
        }

        if (isset($_GET['projectSubmit'])) {
            $selectedAttri = $_GET['projectAttributes'];
            foreach ($selectedAttri as $attribute) {
                if (!in_array($attribute, $attributes[$tableName])) {
                    echo "<p style='color:red;'>Error: The attribute '$attribute' does not belong to the table '$tableName'.</p>";
                }
                // echo "<label><input type='checkbox' name='projectAttributes[]' value='$attribute'> $attribute </label><br>";
            }
        }
        ?>
        <br>
        <input type="submit" value="Submit" name="projectSubmit"></p>
    </form>

    <hr />

    <!-- <h2>JOIN Query</h2> -->
    <h2>Search which games are under a specific genre</h2>
    <form method="GET" action="database.php"> <!--refresh page when submitted-->
        <input type="hidden" id="joinQueryRequest" name="joinQueryRequest">
        Genre : <select name="joinGenre">
            <option value='RPG'>RPG</option>
            <option value='Action'>Action</option>
            <option value='Moba'>Moba</option>
            <option value='Racing'>Racing</option>
            <option value='Sandbox'>Sandbox</option>
        </select> <br /><br />
        <input type="submit" value="Find" name="joinSubmit"></p>
    </form>
    <hr />


    <!-- <h2>Aggregation with GROUP BY Query</h2> -->
    <h2>Count the number of games each user have </h2>
    <form method="GET" action="database.php"> <!--refresh page when submitted-->
        <input type="hidden" id="aggregationGroupByQueryRequest" name="aggregationGroupByQueryRequest">
        <input type="submit" value="Find" name="aggGroupBySubmit"></p>
    </form>
    <hr />

    <!-- <h2>Aggregation with HAVING Query</h2> -->
    <h2>Find how many people are playing the specific genre of game </h2>
    <form method="GET" action="database.php"> <!--refresh page when submitted-->
        <input type="hidden" id="HavingQueryRequest" name="HavingQueryRequest">
        Genre : <select name="Genren">
            <option value='RPG'>RPG</option>
            <option value='Action'>Action</option>
            <option value='Moba'>Moba</option>
            <option value='Racing'>Racing</option>
            <option value='Sandbox'>Sandbox</option>
        </select> <br /><br />
        <input type="submit" value="Find" name="HavingSubmit"></p>
    </form>
    <hr />

    <!-- <h2>Nested Aggregation with GROUP BY Query</h2> -->
    <h2>Find average prices for the genres that have more than 1 games </h2>
    <form method="GET" action="database.php"> <!--refresh page when submitted-->
        <input type="hidden" id="nestedQueryRequest" name="nestedQueryRequest">
        <input type="submit" value="Find" name="nestedSubmit"></p>
    </form>

    <hr />

    <!-- <h2>Division Query</h2> -->
    <h2>Find the company name who've participated all the sales events</h2>
    <form method="GET" action="database.php"> <!--refresh page when submitted-->
        <input type="hidden" id="DivisionQueryRequest" name="DivisionQueryRequest">
        <input type="submit" value="Find" name="DivisionSubmit"></p>
    </form>

    <?php
    //this tells the system that it's no longer just parsing html; it's now parsing PHP

    $success = True; //keep track of errors so it redirects the page only if there are no errors
    $db_conn = NULL; // edit the login credentials in connectToDB()
    $show_debug_alert_messages = False; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())

    function debugAlertMessage($message)
    {
        global $show_debug_alert_messages;

        if ($show_debug_alert_messages) {
            echo "<script type='text/javascript'>alert('" . $message . "');</script>";
        }
    }

    function executePlainSQL($cmdstr)
    { //takes a plain (no bound variables) SQL command and executes it
        //echo "<br>running ".$cmdstr."<br>";
        global $db_conn, $success;

        $statement = OCIParse($db_conn, $cmdstr);
        //There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

        if (!$statement) {
            echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
            $e = OCI_Error($db_conn); // For OCIParse errors pass the connection handle
            echo htmlentities($e['message']);
            $success = False;
        }

        $r = OCIExecute($statement, OCI_DEFAULT);
        if (!$r) {
            echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
            $e = oci_error($statement); // For OCIExecute errors pass the statementhandle
            echo htmlentities($e['message']);
            $success = False;
        }

        return $statement;
    }

    function executeBoundSQL($cmdstr, $list)
    {
        /* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
		In this case you don't need to create the statement several times. Bound variables cause a statement to only be
		parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
		See the sample code below for how this function is used */

        global $db_conn, $success;
        $statement = OCIParse($db_conn, $cmdstr);

        if (!$statement) {
            echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
            $e = OCI_Error($db_conn);
            echo htmlentities($e['message']);
            $success = False;
        }

        foreach ($list as $tuple) {
            foreach ($tuple as $bind => $val) {
                //echo $val;
                //echo "<br>".$bind."<br>";
                OCIBindByName($statement, $bind, $val);
                unset($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
            }

            $r = OCIExecute($statement, OCI_DEFAULT);
            if (!$r) {
                echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($statement); // For OCIExecute errors, pass the statementhandle
                echo htmlentities($e['message']);
                echo "<br>";
                $success = False;
            }
        }
    }

    function handleHavingRequest()
    {
        global $db_conn;

        $result = executePlainSQL(
            "SELECT DISTINCT COUNT(o.UserID), gn.Name
             FROM Own o,BelongsTo bt, GenreDescription gd, GenreName gn
             WHERE bt.GID = o.GID AND bt.GeID = gd.GeID AND gd.Description = gn.Description
             GROUP BY gn.Name
             Having gn.Name = '{$_GET['Genren']}'

            "
        );
        OCICommit($db_conn);
        echo "<table border = 1 cellspacing = 0 width = 400 height = 300>";
        echo "
            <caption> Genre Found </caption>
            <tr>
                <th>Genre Name</th>
                <th>Number of Player</th>
            </tr>
        ";
        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "
                    <tr>
                        <td>" . $row[1] . "</td>
                        <td>" . $row[0] . "</td>
                    </tr>
                ";
        }
        echo "</table>";
    }


    function handleSelectionRequest($selectedAttri)
    {
        global $db_conn;
        $selectedColumns = implode(", ", $selectedAttri);
        $price = $_GET['PriceInput'];
        $releaseDate = $_GET['releaseDateInput'];

        if ($price && $releaseDate) {
            $result = executePlainSQL("SELECT Name, $selectedColumns FROM GamePrice WHERE Release_Date < TO_DATE('" . $releaseDate . "') AND Price < $price");
        } else if ($price) {
            $result = executePlainSQL("SELECT Name, $selectedColumns FROM GamePrice WHERE Price < $price");
        } else if ($releaseDate) {
            $result = executePlainSQL("SELECT Name, $selectedColumns FROM GamePrice WHERE Release_Date < TO_DATE('" . $releaseDate . "')");
        }

        OCICommit($db_conn);
        echo "<table border='1' cellspacing='0' width='400' height='300'>";
        echo "<caption>Selection Results</caption>";
        echo "<tr>";
        echo "<th>Game Name</th>";
        foreach ($selectedAttri as $attr) {
            echo "<th>$attr</th>";
        }
        echo "</tr>";

        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "<tr>";
            echo "<th>" . $row[0] . "</th>";
            for ($i = 1; $i <= count($selectedAttri); $i++) {
                echo "<th>$row[$i]</th>";
            }
            echo "</tr>";
        }
        echo "</table>";

        OCICommit($db_conn);
    }

    function handleDivisionRequest()
    {
        global $db_conn;

        $result = executePlainSQL("
        SELECT DISTINCT C.Name
        FROM CompanyInfo C, SalesEventContent S2
        WHERE NOT EXISTS
        ((SELECT S.SID
          FROM  SalesEventContent S)
          MINUS
          (SELECT S1.SID
           FROM SalesEventContent S1
           WHERE S1.CID = C.CID))
        ");
        OCICommit($db_conn);
        echo "<table border = 1 cellspacing = 0 width = 400 height = 300>";
        echo "
            <tr>
                <th>Company Name</th>
            </tr>
        ";

        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "
                <tr>
                    <td>" . $row[0] . "</td> 
                <tr/>
            ";
        }
        echo "</table>";
    }

    function printResult()
    {
        $userInfo = executePlainSQL("SELECT * FROM UserInfo");

        echo "<table border = 1 cellspacing = 0 width = 400 height = 300>";
        echo "
                <caption> UserInfo </caption>
                <tr>
                    <th>User ID</th>
                    <th>User Location</th>
                    <th>Phone Number</th>
                    <th>Playtime</th>
                    <th>Profile URL</th>
                </tr>
            
            ";

        while ($row = OCI_Fetch_Array($userInfo, OCI_BOTH)) {
            echo "
                    <tr>
                        <td>" . $row[1] . "</td>
                        <td>" . $row[2] . "</td>
                        <td>" . $row[3] . "</td>
                        <td>" . $row[0] . "</td>
                        <td>" . $row[4] . "</td>
                    </tr>
                ";
        }
        echo "</table>";


        $UserProfile = executePlainSQL("SELECT * FROM UserProfile");

        echo "<br><br> <table border = 1 cellspacing = 0 width = 400 height = 300>";
        echo "
                <caption> UserProfile </caption>
                <tr>
                    <th>Profile_URL</th>
                    <th>User_name</th>
                    <th>Creation_Date</th>
                    <th>Account_Level</th>
                </tr>
            
            ";

        while ($row = OCI_Fetch_Array($UserProfile, OCI_BOTH)) {
            echo "
                    <tr>
                        <td>" . $row[0] . "</td>
                        <td>" . $row[1] . "</td>
                        <td>" . $row[2] . "</td>
                        <td>" . $row[3] . "</td>
                    </tr>
                ";
        }
        echo "</table>";
    }

    function connectToDB()
    {
        global $db_conn;

        // Your username is ora_(CWL_ID) and the password is a(student number). For example,
        // ora_platypus is the username and a12345678 is the password.
        $db_conn = OCILogon("ora_lunawwy", "a97806434", "dbhost.students.cs.ubc.ca:1522/stu");

        if ($db_conn) {
            debugAlertMessage("Database is Connected");
            return true;
        } else {
            debugAlertMessage("Cannot connect to Database");
            $e = OCI_Error(); // For OCILogon errors pass no handle
            echo htmlentities($e['message']);
            return false;
        }
    }

    function disconnectFromDB()
    {
        global $db_conn;

        debugAlertMessage("Disconnect from Database");
        OCILogoff($db_conn);
    }

    function handleInsertRequest()
    {
        global $db_conn, $success;
        //Getting the values from user and insert data into the table
        $Playtime = 0.0; // set playtime defult to 0.0 with the new user
        $defult = 'https://steamcommunity.com/id/';
        $string = '/';
        $idm = $_POST['UserID'] . $string;
        $Profile_URL = $defult . $idm; // give the proile_url
        $tuple = array(
            ":Playtime" => $Playtime,
            ":UserID" => $_POST['UserID'],
            ":UserLocation" => $_POST['UserLocation'],
            ":PhoneNum" => $_POST['PhoneNum'],
            ":Profile_URL" => $Profile_URL

        );

        $alltuples = array(
            $tuple
        );

        date_default_timezone_set('Canada/Vancouver');
        $date = date('d-M-Y'); // give the system click time
        $level = 1; // set defult to 1 in the account level for new user
        $tuple1 = array(
            ":Profile_URL" => $Profile_URL,
            ":User_name" => $_POST['User_name'],
            ":Creation_Date" => $date,
            ":Account_Level" => $level
        );

        $alltuples1 = array(
            $tuple1
        );
        // call the referenced table
        executeBoundSQL("insert into UserProfile values (:Profile_URL, :User_name, :Creation_Date, :Account_Level)", $alltuples1);
        executeBoundSQL("insert into UserInfo values (:Playtime, :UserID, :UserLocation, :PhoneNum, :Profile_URL)", $alltuples);
        OCICommit($db_conn);

        if ($success) {
            $message = 'New user ' . $_POST['User_name'] . ' is added';
        } else {
            $message = "Action failed: User exisit. Please try again with a different ID";
        }
        printResult();
        echo "<script>alert('" . $message . "')</script>";
    }

    // update location by user ID
    function handleUpdateRequest()
    {
        global $db_conn, $success;

        $user_id = $_POST['userID'];
        $new_user_name = $_POST['User_name'];
        $new_location = $_POST['newLoc'];
        $new_phone_number = $_POST['phone'];

        $profileURL = 'https://steamcommunity.com/id/' . $user_id . '/';

        // you need the wrap the old name and new name values with single quotations
        if ($new_user_name) {
            executePlainSQL("UPDATE UserProfile SET User_name='" . $new_user_name . "' WHERE Profile_URL='" . $profileURL . "'");
        }
        if ($new_location) {
            executePlainSQL("UPDATE UserInfo SET UserLocation='" . $new_location . "' WHERE UserID='" . $user_id . "'");
        }
        if ($new_phone_number) {
            executePlainSQL("UPDATE UserInfo SET PhoneNum='" . $new_phone_number . "' WHERE UserID='" . $user_id . "'");
        }
        OCICommit($db_conn);
        if ($success) {
            $message = "User Information is updated";
        } else {
            $message = "Action failed. Please try again";
        }
        printResult();
        echo "<script>alert('" . $message . "')</script>";
    }

    function handleResetRequest()
    {
        global $db_conn;
        // Drop old table
        executePlainSQL("DROP TABLE demoTable");

        // Create new table
        echo "<br> creating new table <br>";
        executePlainSQL("CREATE TABLE demoTable (id int PRIMARY KEY, name char(30))");
        OCICommit($db_conn);
    }


    function handleJoinRequest()
    {
        global $db_conn;

        $result = executePlainSQL(
            "   SELECT DISTINCT gu.Name, gu.URL
                FROM GameInfo gi,BelongsTo bt, GenreDescription gd, GenreName gn, GameURL gu
                WHERE bt.GID = gi.GID AND bt.GeID = gd.GeID AND gd.Description = gn.Description AND gu.URL = gi.URL AND gn.Name = '{$_GET['joinGenre']}'
            "
        );
        OCICommit($db_conn);
        echo "<table border = 1 cellspacing = 0 width = 400 height = 300>";
        echo "
            <caption> Game Found </caption>
            <tr>
                <th>Game Name</th>
                <th>Game URL</th>
            </tr>
        ";
        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "
                    <tr>
                        <td>" . $row[0] . "</td>
                        <td>" . $row[1] . "</td>
                    </tr>
                ";
        }
        echo "</table>";
    }

    function handleProjectRequest($tableName, $selectedAttributes)
    {
        global $db_conn;

        $selectedColumns = implode(", ", $selectedAttributes);
        $result = executePlainSQL("SELECT $selectedColumns FROM $tableName");
        if (!$result) {
            echo "Failed to execute query";
            return;
        }
        OCICommit($db_conn);


        echo "<table border='1' cellspacing='0' width='400' height='300'>";
        echo "<caption>Projection Results</caption>";
        echo "<tr>";
        foreach ($selectedAttributes as $attr) {
            echo "<th>$attr</th>";
        }
        echo "</tr>";
        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "<tr>";
            for ($i = 0; $i < count($selectedAttributes); $i++) {
                $attr = $row[$i];
                echo "<th>$attr</th>";
            }
            echo "</tr>";
        }
        echo "</table>";
    }

    function handleDeleteRequest()
    {
        global $db_conn, $success;

        $userID = $_POST['deleteUserID'];
        $profileURL = 'https://steamcommunity.com/id/' . $userID . '/';
        // if ($profileURL == 'https://steamcommunity.com/id/5/')
        //     echo 'this';

        executePlainSQL("DELETE FROM UserProfile up WHERE up.Profile_URL = '" . $profileURL . "'");

        OCICommit($db_conn);

        if ($success) {
            $message = "User is deleted";
        } else {
            $message = "Action failed. Please try again";
        }
        printResult();
        echo "<script>alert('" . $message . "')</script>";
    }

    function handleAggGroupByRequest()
    {
        global $db_conn;

        $result = executePlainSQL("
            SELECT o.UserID, up.User_name, COUNT(*)
            FROM Own o, UserProfile up, UserInfo ui
            WHERE o.UserID = ui.UserID AND ui.Profile_URL = up.Profile_URL
            GROUP BY o.UserID, up.User_name
        ");
        OCICommit($db_conn);
        echo "<table border = 1 cellspacing = 0 width = 400 height = 300>";
        echo "
            <tr>
                <th>User ID</th>
                <th>User Name</th>
                <th>Number of Games</th>
            </tr>
        ";

        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "
                <tr>
                    <td>" . $row[0] . "</td> 
                    <td>" . $row[1] . "</td> 
                    <td>" . $row[2] . "</td> 
                <tr/>
            ";
        }
        echo "</table>";
    }

    function handleNestedRequest()
    {
        global $db_conn;

        $result = executePlainSQL("
            SELECT gd.GeID, gn.Name, AVG(gp.price)
            FROM GameInfo gi,BelongsTo bt, GenreDescription gd, GameURL gu, GamePrice gp, GenreName gn
            WHERE bt.GID = gi.GID AND bt.GeID = gd.GeID AND gi.URL = gu.URL AND gu.Name = gp.Name AND gu.Release_Date = gp.Release_Date AND gd.description = gn.description
            GROUP BY gd.GeID, gn.Name
            Having 1 < (SELECT COUNT(*)
                        FROM BelongsTo bt1
                        WHERE bt1.GeID = gd.GeID
                        GROUP BY bt1.GeID)
        ");
        OCICommit($db_conn);
        echo "<table border='1' cellspacing='0' width='400' height='300'>";
        echo "
            <tr>
                <th>Genre ID</th>
                <th>Genre Name</th>
                <th>Average Price</th>
            </tr>
        ";

        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "
                <tr>
                    <td>" . $row[0] . "</td> 
                    <td>" . $row[1] . "</td> 
                    <td>" . $row[2] . "</td> 
                <tr/>
            ";
        }
        echo "</table>";
    }

    function handleInitializeRequest()
    {
        printResult();
    }

    // HANDLE ALL POST ROUTES
    // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
    function handlePOSTRequest()
    {
        if (connectToDB()) {
            if (array_key_exists('resetTablesRequest', $_POST)) {
                handleResetRequest();
            } else if (array_key_exists('updateQueryRequest', $_POST)) {
                handleUpdateRequest();
            } else if (array_key_exists('insertQueryRequest', $_POST)) {
                handleInsertRequest();
            } else if (array_key_exists('deleteQueryRequest', $_POST)) {
                handleDeleteRequest();
            } else if (array_key_exists('initializeTablesRequest', $_POST)) {
                handleInitializeRequest();
            }

            disconnectFromDB();
        }
    }

    // HANDLE ALL GET ROUTES
    // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
    function handleGETRequest()
    {
        if (connectToDB()) {
            if (array_key_exists('countTuples', $_GET)) {
                handleCountRequest();
            } else if (array_key_exists('joinSubmit', $_GET)) {
                handleJoinRequest();
            } else if (array_key_exists('selectionSubmit', $_GET)) {
                $selectedAttri = $_GET['attri'];
                handleSelectionRequest($selectedAttri);
            } else if (array_key_exists('aggGroupBySubmit', $_GET)) {
                handleAggGroupByRequest();
            } else if (array_key_exists('HavingSubmit', $_GET)) {
                handleHavingRequest();
            } else if (array_key_exists('projectSubmit', $_GET)) {
                $tableName = $_GET['projectTable'];
                $selectedAttributes = $_GET['projectAttributes'];
                handleProjectRequest($tableName, $selectedAttributes);
            } else if (array_key_exists('nestedSubmit', $_GET)) {
                handleNestedRequest();
            } else if (array_key_exists('DivisionSubmit', $_GET)) {
                handleDivisionRequest();
            }

            disconnectFromDB();
        }
    }

    if (isset($_POST['reset']) || isset($_POST['updateSubmit']) || isset($_POST['insertSubmit']) || isset($_POST['deleteSubmit']) || isset($_POST['initializeSubmit'])) {
        handlePOSTRequest();
    } else if (isset($_GET['countTupleRequest']) || isset($_GET['joinQueryRequest']) || isset($_GET['selectionQueryRequest']) || isset($_GET['aggregationGroupByQueryRequest']) || isset($_GET['HavingQueryRequest']) || isset($_GET['projectQueryRequest']) || isset($_GET['nestedQueryRequest']) || isset($_GET['DivisionQueryRequest'])) {
        handleGETRequest();
    }
    ?>
</body>

</html>