const express = require("express");
const bcrypt = require("bcrypt");
const path = require("path");
const fs = require('fs');
const db = require("./db");

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, "public")));


app.use((req, res, next) => {
    if (req.path.endsWith(".html")) {
        return res.redirect(req.path.replace(".html", ""));
    }
    next();
});

app.get("/:page", (req, res, next) => {
    if (req.params.page.includes(".")) return next(); 
    const filePath = path.join(__dirname, "public", `${req.params.page}.html`);
    fs.access(filePath, fs.constants.F_OK, (err) => {
        if (err) {
            return next();
        }
        res.sendFile(filePath, (err) => {
            if (err) {
                res.status(404).send("Page Not Found");
            }
        });
    });
});






















































// ---------------------- EXPENSES -------------------------------
app.get("/allexpenses", (req, res) => {
    const sql = `
        SELECT e.ExpenseID, e.DateEncoded, e.Description, e.Amount, e.DateUsed, e.AmountGiven, e.DateGiven,
               p.FirstName AS PersonFirstName, p.LastName AS PersonLastName,
               o.OfficerID, o.RoleDescription,
               ev.EventName
        FROM expenses e
        LEFT JOIN person p ON e.PersonID = p.PersonID
        LEFT JOIN officer o ON e.OfficerID = o.OfficerID
        LEFT JOIN eventtype ev ON e.EventTypeID = ev.EventTypeID
    `;
    
    db.query(sql, (err, results) => {
        if (err) {
            return res.json({ status: "error", message: err.message });
        }
        res.json({ status: "success", data: results });
    });
});

app.post("/updateExpense", (req, res) => {
    const { ExpenseID, Description, Amount, DateUsed, AmountGiven, DateGiven } = req.body;

    if (!ExpenseID || !Description || !Amount) {
        return res.status(400).json({ success: false, message: "Expense ID, Description, and Amount are required." });
    }

    const query = `
        UPDATE expenses 
        SET Description = ?, Amount = ?, DateUsed = ?, AmountGiven = ?, DateGiven = ? 
        WHERE ExpenseID = ?`;

    db.query(query, [Description, Amount, DateUsed, AmountGiven, DateGiven, ExpenseID], (err, result) => {
        if (err) {
            console.error("Error updating expense:", err);
            return res.status(500).json({ success: false, message: "Error updating expense." });
        }

        res.json({ success: true, message: "Expense updated successfully." });
    });
});

app.delete("/deleteExpense/:expenseId", (req, res) => {
    const expenseId = req.params.expenseId;

    if (!expenseId) {
        return res.status(400).json({ success: false, message: "Expense ID is required." });
    }

    const query = "DELETE FROM expenses WHERE ExpenseID = ?";

    db.query(query, [expenseId], (err, result) => {
        if (err) {
            console.error("Error deleting expense:", err);
            return res.status(500).json({ success: false, message: "Error deleting expense." });
        }

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: "Expense not found." });
        }

        res.json({ success: true, message: "Expense deleted successfully." });
    });
});


// ---------------------- EXPENSES -------------------------------





// ---------------------- USERS -------------------------------
app.get("/allusers", (req, res) => {
    const sql = `
        SELECT p.PersonID, p.FirstName, p.LastName, p.ContactNumber, 
               l.LoginID, l.Username, 
               o.OfficerID, o.RoleDescription
        FROM person p
        LEFT JOIN officer o ON p.PersonID = o.PersonID
        LEFT JOIN login l ON o.OfficerID = l.OfficerID
    `;
    
    db.query(sql, (err, results) => {
        if (err) {
            return res.json({ status: "error", message: err.message });
        }
        res.json({ status: "success", data: results });
    });
});

app.get("/getUser/:id", (req, res) => {
    const userId = req.params.id;

    const query = `
        SELECT p.PersonID, p.FirstName, p.LastName, p.ContactNumber, 
               l.Username, o.RoleDescription
        FROM person p
        LEFT JOIN officer o ON p.PersonID = o.PersonID
        LEFT JOIN login l ON o.OfficerID = l.OfficerID
        WHERE p.PersonID = ?`;

    db.query(query, [userId], (err, results) => {
        if (err) {
            return res.status(500).json({ success: false, message: "Error fetching user data." });
        }

        if (results.length === 0) {
            return res.status(404).json({ success: false, message: "User not found." });
        }

        res.json({ success: true, data: results[0] });
    });
});

app.post("/updateUser", (req, res) => {
    const { PersonID, FirstName, LastName, ContactNumber, RoleDescription, Username } = req.body;

    if (!PersonID || !FirstName || !LastName || !Username) {
        return res.status(400).json({ success: false, message: "All fields are required." });
    }

    const updateUserQuery = `
        UPDATE person p
        JOIN officer o ON p.PersonID = o.PersonID
        JOIN login l ON o.OfficerID = l.OfficerID
        SET p.FirstName = ?, p.LastName = ?, p.ContactNumber = ?, o.RoleDescription = ?, l.Username = ?
        WHERE p.PersonID = ?`;

    db.query(updateUserQuery, [FirstName, LastName, ContactNumber, RoleDescription, Username, PersonID], (err, result) => {
        if (err) {
            return res.status(500).json({ success: false, message: "Error updating user." });
        }
        res.json({ success: true, message: "User updated successfully." });
    });
});

app.delete("/deleteUser/:id", (req, res) => {
    const userId = req.params.id;

    db.beginTransaction((err) => {
        if (err) {
            return res.status(500).json({ success: false, message: "Transaction error." });
        }

        // Step 1: Delete from login table
        db.query("DELETE FROM login WHERE OfficerID IN (SELECT OfficerID FROM officer WHERE PersonID = ?)", [userId], (err) => {
            if (err) return db.rollback(() => res.status(500).json({ success: false, message: "Error deleting from login." }));

            // Step 2: Delete payments related to the user
            db.query("DELETE FROM payment WHERE OfficerID IN (SELECT OfficerID FROM officer WHERE PersonID = ?)", [userId], (err) => {
                if (err) return db.rollback(() => res.status(500).json({ success: false, message: "Error deleting related payments." }));

                // Step 3: Delete expenses related to the user
                db.query("DELETE FROM expenses WHERE OfficerID IN (SELECT OfficerID FROM officer WHERE PersonID = ?)", [userId], (err) => {
                    if (err) return db.rollback(() => res.status(500).json({ success: false, message: "Error deleting related expenses." }));

                    // Step 4: Delete revenues related to the user
                    db.query("DELETE FROM revenues WHERE InchargeID IN (SELECT OfficerID FROM officer WHERE PersonID = ?)", [userId], (err) => {
                        if (err) return db.rollback(() => res.status(500).json({ success: false, message: "Error deleting related revenues." }));

                        // Step 5: Delete from recordkeeper table
                        db.query("DELETE FROM recordkeeper WHERE PersonID = ?", [userId], (err) => {
                            if (err) return db.rollback(() => res.status(500).json({ success: false, message: "Error deleting from recordkeeper." }));

                            // Step 6: Delete from incharge table
                            db.query("DELETE FROM incharge WHERE PersonID = ?", [userId], (err) => {
                                if (err) return db.rollback(() => res.status(500).json({ success: false, message: "Error deleting from incharge." }));

                                // Step 7: Delete from officer table
                                db.query("DELETE FROM officer WHERE PersonID = ?", [userId], (err) => {
                                    if (err) return db.rollback(() => res.status(500).json({ success: false, message: "Error deleting from officer." }));

                                    // Step 8: Finally, delete from person table
                                    db.query("DELETE FROM person WHERE PersonID = ?", [userId], (err, result) => {
                                        if (err) return db.rollback(() => res.status(500).json({ success: false, message: "Error deleting from person." }));

                                        if (result.affectedRows === 0) {
                                            return db.rollback(() => res.status(404).json({ success: false, message: "User not found." }));
                                        }

                                        db.commit((err) => {
                                            if (err) return db.rollback(() => res.status(500).json({ success: false, message: "Commit error." }));

                                            res.json({ success: true, message: "User deleted successfully." });
                                        });
                                    });
                                });
                            });
                        });
                    });
                });
            });
        });
    });
});

// ---------------------- USERS -------------------------------





// ---------------------- FOR REVENUES AND PAYMENTS -------------------------------
app.post('/updateRevenue', (req, res) => {
    const updatedData = req.body;
    const query = `
        UPDATE revenues 
        SET EventDate = ?, EventTypeID = ?, Description = ?, InchargeID = ?, AmountGiven = ?, BandShare = ?, MembersTalentFee = ?, KeeperID = ?
        WHERE RevenueID = ?`;
    
    db.query(query, [
        updatedData.EventDate,
        updatedData.EventTypeID,
        updatedData.Description,
        updatedData.InchargeID,
        updatedData.AmountGiven,
        updatedData.BandShare,
        updatedData.MembersTalentFee,
        updatedData.KeeperID,
        updatedData.RevenueID
    ], (err, result) => {
        if (err) {
            return res.status(500).json({ success: false, message: "Error updating revenue." });
        }
        res.json({ success: true, message: "Revenue updated successfully." });
    });
});




app.post('/addRevenue', (req, res) => {
    const { eventDate, eventTypeID, description, inchargeID, amountGiven, bandShare, membersTalentFee, keeperID } = req.body;

    const query = `
        INSERT INTO revenues (EventDate, EventTypeID, Description, InchargeID, AmountGiven, BandShare, MembersTalentFee, KeeperID)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;
    
    const values = [eventDate, eventTypeID, description, inchargeID, amountGiven, bandShare, membersTalentFee, keeperID];

    db.query(query, values, (err, result) => {
        if (err) {
            console.error('Error details:', err); // Log the error for debugging
            return res.json({ message: 'Error inserting data' });
        }

        res.json({ message: 'Revenue data added successfully!' });
    });
});

app.post("/payments/update-payment", (req, res) => {
    const { paymentID, paymentDate, modeOfPayment, amountPaid, remarks, balance, dateReceived, officerID } = req.body;
    
    const sql = `UPDATE payment SET PaymentDate = ?, ModeOfPayment = ?, AmountPaid = ?, Remarks = ?, Balance = ?, DateReceived = ?, OfficerID = ? WHERE PaymentID = ?`;
    const values = [paymentDate, modeOfPayment, amountPaid, remarks, balance, dateReceived, officerID, paymentID];
    
    db.query(sql, values, (err, result) => {
        if (err) {
            return res.json({ status: "error", message: err.message });
        }
        res.json({ status: "success", message: "Payment updated successfully." });
    });
});






app.get("/allrevenues", (req, res) => {
    const sql = `
        SELECT 
            r.RevenueID, 
            r.EventDate, 
            e.EventName, 
            r.Description, 
            r.AmountGiven, 
            r.BandShare, 
            r.MembersTalentFee, 
            p.FirstName AS InchargeFirstName, 
            p.LastName AS InchargeLastName,
            k.FirstName AS KeeperFirstName,
            k.LastName AS KeeperLastName,
            a.NumberOfMembers
        FROM revenues r
        LEFT JOIN eventtype e ON r.EventTypeID = e.EventTypeID
        LEFT JOIN incharge i ON r.InchargeID = i.InchargeID
        LEFT JOIN person p ON i.PersonID = p.PersonID
        LEFT JOIN recordkeeper rk ON r.KeeperID = rk.KeeperID
        LEFT JOIN person k ON rk.PersonID = k.PersonID
        LEFT JOIN attendance a 
            ON r.EventTypeID = a.EventTypeID  
            AND r.EventDate = a.date  
        ORDER BY r.RevenueID DESC        
    `;

    db.query(sql, (err, results) => {
        if (err) {
            console.error("Error fetching revenues:", err);
            return res.status(500).json({ error: "Database error" });
        }
        res.json(results);
    });
});

app.get("/payments/:revenueId", (req, res) => {
    const revenueId = req.params.revenueId;
    const query = `
        SELECT 
            e.*,
            r.*,
            p.*, 
            per.FirstName AS OfficerFirstName, 
            per.LastName AS OfficerLastName
        FROM payment p
        LEFT JOIN officer o ON p.OfficerID = o.OfficerID
        LEFT JOIN person per ON o.PersonID = per.PersonID
        LEFT JOIN revenues r ON r.RevenueID = p.RevenueID
        LEFT JOIN eventtype e ON e.EventTypeID = r.EventTypeID
        WHERE p.RevenueID = ?
        ORDER BY p.PaymentID DESC;
    `;

    db.query(query, [revenueId], (error, results) => {
        if (error) {
            console.error("Error fetching payments:", error);
            return res.status(500).json({ error: "Internal server error" });
        }

        if (results.length === 0) {
            return res.status(404).json({ error: "No payment records found" });
        }

        res.json(results);
    });
});




app.post("/add-payment", (req, res) => {
    const { revenueId, paymentDate, modeOfPayment, amountPaid, remarks, balance, dateReceived, officerId } = req.body;

    const query = `INSERT INTO payment (RevenueID, PaymentDate, ModeOfPayment, AmountPaid, Remarks, Balance, DateReceived, OfficerID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;

    db.query(query, [revenueId, paymentDate, modeOfPayment, amountPaid, remarks, balance, dateReceived, officerId], (err, result) => {
        if (err) {
            console.error("Error inserting payment:", err);
            return res.status(500).json({ error: "Database error" });
        }
        res.json({ success: true, message: "Payment added successfully!" });
    });
});

app.get("/get-payment-modes", (req, res) => {
    const query = "SHOW COLUMNS FROM payment LIKE 'ModeOfPayment'";

    db.query(query, (err, results) => {
        if (err) {
            console.error("Error fetching payment modes:", err);
            return res.status(500).json({ error: "Database error" });
        }

        const enumValues = results[0].Type.match(/'([^']+)'/g).map(val => val.replace(/'/g, ""));
        res.json(enumValues);
    });
});

app.get("/get-remarks", (req, res) => {
    const query = "SHOW COLUMNS FROM payment LIKE 'Remarks'";

    db.query(query, (err, results) => {
        if (err) {
            console.error("Error fetching remarks:", err);
            return res.status(500).json({ error: "Database error" });
        }

        const enumValues = results[0].Type.match(/'([^']+)'/g).map(val => val.replace(/'/g, ""));
        res.json(enumValues);
    });
});

app.delete("/delete-payment/:paymentID", (req, res) => {
    const paymentID = req.params.paymentID;
    const query = "DELETE FROM payment WHERE PaymentID = ?";

    db.query(query, [paymentID], (err, result) => {
        if (err) {
            console.error("Error deleting payment:", err);
            return res.status(500).json({ error: "Database error" });
        }

        if (result.affectedRows > 0) {
            res.json({ success: true, message: "Payment deleted successfully" });
        } else {
            res.status(404).json({ error: "Payment not found" });
        }
    });
});
app.get("/allpayments", (req, res) => {
    const query = `
        SELECT 
            e.*,
            r.*,
            p.*, 
            per.FirstName AS OfficerFirstName, 
            per.LastName AS OfficerLastName
        FROM payment p
        LEFT JOIN officer o ON p.OfficerID = o.OfficerID
        LEFT JOIN person per ON o.PersonID = per.PersonID
        LEFT JOIN revenues r ON r.RevenueID = p.RevenueID
        LEFT JOIN eventtype e ON e.EventTypeID = r.EventTypeID
        ORDER BY p.PaymentID DESC;
    `;

    db.query(query, (error, results) => {
        if (error) {
            console.error("Error fetching payments:", error);
            return res.status(500).json({ error: "Internal server error" });
        }

        if (results.length === 0) {
            return res.status(404).json({ error: "No payment records found" });
        }

        res.json(results);
    });
});



app.delete('/deleteRevenue/:revenueId', (req, res) => {
    const revenueId = req.params.revenueId;

    db.beginTransaction((err) => {
        if (err) {
            return res.status(500).json({ success: false, message: "Failed to start transaction." });
        }

        const deletePaymentQuery = 'DELETE FROM payment WHERE RevenueID = ?';
        db.query(deletePaymentQuery, [revenueId], (err, result) => {
            if (err) {
                return db.rollback(() => {
                    res.status(500).json({ success: false, message: "Failed to delete payments." });
                });
            }

            const deleteRevenueQuery = 'DELETE FROM revenues WHERE RevenueID = ?';
            db.query(deleteRevenueQuery, [revenueId], (err, result) => {
                if (err) {
                    return db.rollback(() => {
                        res.status(500).json({ success: false, message: "Failed to delete revenue." });
                    });
                }

                db.commit((err) => {
                    if (err) {
                        return db.rollback(() => {
                            res.status(500).json({ success: false, message: "Failed to commit transaction." });
                        });
                    }

                    res.json({ success: true, message: "Revenue and related payment records deleted successfully." });
                });
            });
        });
    });
});



// ---------------------- FOR REVENUES AND PAYMENTS -------------------------------





// ---------------------- FOR ATTENDANCES -------------------------------
app.get("/allattendances", (req, res) => {
    const sql = `
        SELECT a.AttendanceID, e.EventName, a.NumberOfMembers, a.date 
        FROM attendance a
        JOIN eventtype e ON a.EventTypeID = e.EventTypeID
        ORDER BY a.AttendanceID DESC
    `;
    db.query(sql, (err, results) => {
        if (err) {
            return res.status(500).json({ message: "Error fetching attendance data" });
        }
        res.json(results);
    });
});

app.post("/add_attendance", (req, res) => {
    const { EventTypeID, NumberOfMembers, date } = req.body;

    if (!EventTypeID || !NumberOfMembers || !date) {
        return res.status(400).json({ message: "All fields are required" });
    }

    const checkSql = `
        SELECT a.*, e.EventName 
        FROM attendance a
        JOIN eventtype e ON a.EventTypeID = e.EventTypeID
        WHERE a.EventTypeID = ? AND a.date = ?`;

    db.query(checkSql, [EventTypeID, date], (err, results) => {
        if (err) {
            return res.status(500).json({ message: "Error checking attendance record" });
        }
        if (results.length > 0) {
            return res.status(400).json({ message: `Attendance for '${results[0].EventName}' on ${date} already exists` });
        }

        const insertSql = "INSERT INTO attendance (EventTypeID, NumberOfMembers, date) VALUES (?, ?, ?)";
        db.query(insertSql, [EventTypeID, NumberOfMembers, date], (err, result) => {
            if (err) {
                return res.status(500).json({ message: "Error adding attendance" });
            }
            res.json({ message: "Attendance added successfully", AttendanceID: result.insertId });
        });
    });
});


app.delete("/delete_attendance/:id", (req, res) => {
    const { id } = req.params;

    const checkSql = "SELECT * FROM attendance WHERE AttendanceID = ?";
    db.query(checkSql, [id], (err, results) => {
        if (err) {
            return res.status(500).json({ message: "Error checking attendance record" });
        }
        if (results.length === 0) {
            return res.status(404).json({ message: "Attendance record not found" });
        }

        const deleteSql = "DELETE FROM attendance WHERE AttendanceID = ?";
        db.query(deleteSql, [id], (err, result) => {
            if (err) {
                return res.status(500).json({ message: "Error deleting attendance record" });
            }
            res.json({ message: "Attendance deleted successfully" });
        });
    });
});


// ---------------------- FOR ATTENDANCES -------------------------------




// ---------------------- FOR EVENTS -------------------------------


app.post('/updateEvent', (req, res) => {
    const { eventId, eventName } = req.body;

    if (!eventId || !eventName) {
        return res.json({ message: "Event ID and Event Name are required" });
    }

    db.query(
        "SELECT * FROM eventtype WHERE EventName = ? AND EventTypeID != ?",
        [eventName, eventId],
        (err, results) => {
            if (err) {
                return res.json({ message: "Error checking for duplicate event name", error: err.message });
            }

            if (results.length > 0) {
                return res.json({ message: "Event name already exists. Please choose a different name." });
            }

            db.query(
                "UPDATE eventtype SET EventName = ? WHERE EventTypeID = ?",
                [eventName, eventId],
                (err, results) => {
                    if (err) {
                        return res.json({ message: "Error updating event", error: err.message });
                    }

                    if (results.affectedRows === 0) {
                        return res.json({ message: "Event not found" });
                    }

                    res.json({ message: "Event updated successfully" });
                }
            );
        }
    );
});



app.get("/allevents", (req, res) => {
    const sql = "SELECT * FROM eventtype ORDER BY EventTypeID DESC";
    db.query(sql, (err, results) => {
        if (err) {
            return res.status(500).json({ message: "Error fetching events" });
        }
        res.json(results);
    });
});

app.post("/add_event", (req, res) => {
    const { eventName } = req.body;
    if (!eventName) {
        return res.status(400).json({ message: "Event name is required" });
    }

    const checkSql = "SELECT * FROM eventtype WHERE EventName = ?";
    db.query(checkSql, [eventName], (err, results) => {
        if (err) {
            return res.status(500).json({ message: "Error checking event" });
        }
        if (results.length > 0) {
            return res.status(400).json({ message: "Event name already exists" });
        }

        const insertSql = "INSERT INTO eventtype (EventName) VALUES (?)";
        db.query(insertSql, [eventName], (err, result) => {
            if (err) {
                return res.status(500).json({ message: "Error adding event" });
            }
            res.json({ message: "Event added successfully", eventID: result.insertId });
        });
    });
});



app.delete("/delete_event/:id", (req, res) => {
    const eventTypeID = req.params.id;
    const getRevenueIDsQuery = "SELECT RevenueID FROM revenues WHERE EventTypeID = ?";

    db.query(getRevenueIDsQuery, [eventTypeID], (err, revenueResults) => {
        if (err) return res.status(500).json({ message: "Error retrieving related revenue IDs" });

        const revenueIDs = revenueResults.map(row => row.RevenueID);

        if (revenueIDs.length > 0) {
            const deletePaymentsQuery = "DELETE FROM payment WHERE RevenueID IN (?)";
            db.query(deletePaymentsQuery, [revenueIDs], (err) => {
                if (err) return res.status(500).json({ message: "Error deleting related payments" });

                const deleteRevenuesQuery = "DELETE FROM revenues WHERE EventTypeID = ?";
                db.query(deleteRevenuesQuery, [eventTypeID], (err) => {
                    if (err) return res.status(500).json({ message: "Error deleting related revenues" });

                    const deleteExpensesQuery = "DELETE FROM expenses WHERE EventTypeID = ?";
                    db.query(deleteExpensesQuery, [eventTypeID], (err) => {
                        if (err) return res.status(500).json({ message: "Error deleting related expenses" });

                        const deleteEventQuery = "DELETE FROM eventtype WHERE EventTypeID = ?";
                        db.query(deleteEventQuery, [eventTypeID], (err) => {
                            if (err) return res.status(500).json({ message: "Error deleting event" });
                            res.json({ message: "Event deleted successfully" });
                        });
                    });
                });
            });
        } else {
            const deleteExpensesQuery = "DELETE FROM expenses WHERE EventTypeID = ?";
            db.query(deleteExpensesQuery, [eventTypeID], (err) => {
                if (err) return res.status(500).json({ message: "Error deleting related expenses" });

                const deleteEventQuery = "DELETE FROM eventtype WHERE EventTypeID = ?";
                db.query(deleteEventQuery, [eventTypeID], (err) => {
                    if (err) return res.status(500).json({ message: "Error deleting event" });
                    res.json({ message: "Event deleted successfully" });
                });
            });
        }
    });
});

// ---------------------- FOR EVENTS -------------------------------




app.post("/login_process", (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({ error: "All fields are required." });
    }

    db.query("SELECT * FROM login WHERE Username = ?", [username], (err, results) => {
        if (err) return res.status(500).json({ error: "Database error." });

        if (results.length === 0) {
            return res.status(400).json({ error: "Invalid username or password." });
        }

        const user = results[0];

        bcrypt.compare(password, user.Password, (err, isMatch) => {
            if (err) return res.status(500).json({ error: "Error comparing passwords." });

            if (!isMatch) {
                return res.status(400).json({ error: "Invalid username or password." });
            }

            res.json({
                message: "Login successful",
                user: {
                    id: user.OfficerID,
                    username: user.Username
                }
            });
        });
    });
});
app.post("/process_register", async (req, res) => {
    const { firstName, lastName, contactNumber, position, userName, password } = req.body;

    if (!firstName || !lastName || !contactNumber || !position || !userName || !password) {
        return res.status(400).json({ error: "All fields are required." });
    }

    try {
        db.query("SELECT Username FROM login WHERE Username = ?", [userName], async (err, results) => {
            if (err) return res.status(500).json({ error: "Database error." });

            if (results.length > 0) {  
                return res.status(200).json({ success: "Username already exists!" });
            }

            const hashedPassword = await bcrypt.hash(password, 10);

            db.beginTransaction((err) => {
                if (err) return res.status(500).json({ error: "Transaction error." });

                db.query("INSERT INTO person (FirstName, LastName, ContactNumber) VALUES (?, ?, ?)", 
                [firstName, lastName, contactNumber], (err, result) => {
                    if (err) {
                        db.rollback(() => {
                            return res.status(500).json({ error: "Error inserting into person table." });
                        });
                    }
                    
                    const personId = result.insertId;

                    db.query("INSERT INTO officer (PersonID, RoleDescription) VALUES (?, ?)", 
                    [personId, position], (err, result) => {
                        if (err) {
                            db.rollback(() => {
                                return res.status(500).json({ error: "Error inserting into officer table." });
                            });
                        }
                        
                        const officerId = result.insertId;

                        db.query("INSERT INTO login (LoginID, OfficerID, Username, Password) VALUES (?, ?, ?, ?)", 
                        [officerId, officerId, userName, hashedPassword], (err) => {
                            if (err) {
                                db.rollback(() => {
                                    return res.status(500).json({ error: "Error inserting into login table." });
                                });
                            }

                            db.query("INSERT INTO incharge (InchargeID, PersonID) VALUES (?, ?)", [personId, personId], (err) => {
                                if (err) {
                                    db.rollback(() => {
                                        return res.status(500).json({ error: "Error inserting into incharge table." });
                                    });
                                }

                                db.query("INSERT INTO recordkeeper (KeeperID, PersonID, OfficerID) VALUES (?, ?, ?)", [personId, personId, officerId], (err) => {
                                    if (err) {
                                        db.rollback(() => {
                                            return res.status(500).json({ error: "Error inserting into recordkeeper table." });
                                        });
                                    }

                                    db.commit((err) => {
                                        if (err) {
                                            db.rollback(() => {
                                                return res.status(500).json({ error: "Commit error." });
                                            });
                                        }

                                        res.status(200).json({ success: "Registration successful!" });
                                    });
                                });
                            });
                        });
                    });
                });
            });
        });

    } catch (error) {
        res.status(500).json({ error: "Server error." });
    }
});




app.get("/get-officers", (req, res) => {
    const query = "SELECT PersonID, FirstName, LastName FROM person";

    db.query(query, (err, results) => {
        if (err) {
            console.error("Error fetching officers:", err);
            return res.status(500).json({ error: "Database error" });
        }
        res.json(results);
    });
});

app.listen(3000, () => console.log("Server is running on port 3000"));
