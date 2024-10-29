------- CATEGORIES TABLE INSERTION -------
-- Insert one unprotected expense category
INSERT INTO categories (category_id, category_name, category_type, created_at) VALUES 
(1, 'Food', 'expense', '2024-09-20T13:00 +08:00'),
(2, 'Leisure', 'expense', '2024-09-20T13:00 +08:00');
-- ('category_id', '1'),
-- ('category_name', 'Education'),
-- ('catgeory_type', 'expense'),
-- ('createdAt', '2024-09-20T13:00');

-- Insert lending and paying debt category
INSERT INTO categories (category_id, category_name, category_type, created_at, is_protected, additional_information) VALUES 
(3, 'Lending', 'expense', '2024-09-20T13:00 +08:00', 1, 'This category represents a transaction where you give money to someone else, creating a debt where the other person owes you money.'),
(4, 'Paying Debt', 'expense', '2024-09-20T13:00 +08:00', 1, 'This category represents a transaction where you settle a debt that you borrow from other person.');
-- ('category_id', '2'),
-- ('category_name', 'Lending'),
-- ('catgeory_type', 'expense'),
-- ('createdAt', '2024-09-20T13:00'),
-- ('isProtected', 'true');

-- INSERT INTO categories (category_id, category_name, category_type, created_at, is_protected)

-- -- ('category_id', '3'),
-- -- ('category_name', 'Paying Debt'),
-- -- ('catgeory_type', 'expense'),
-- -- ('createdAt', '2024-09-20T13:00'),
-- -- ('isProtected', 'true');

-- Insert one unprotected income category
INSERT INTO categories (category_id, category_name, category_type, created_at) VALUES 
(5, 'Salary', 'income', '2024-09-20T13:00 +08:00'),
(6, 'Allowance', 'income', '2024-09-20T13:00 +08:00');

-- ('category_id', '4'),
-- ('category_name', 'Salary'),
-- ('catgeory_type', 'income'),
-- ('createdAt', '2024-09-20T13:00');

-- Insert borrowing and receive debt catgeory
INSERT INTO categories (category_id, category_name, category_type, created_at, is_protected, additional_information) VALUES
(7, 'Borrowing', 'income', '2024-09-20T13:00 +08:00', 1, 'This category represents a transaction where you receive money from someone, and now you owe them money, creating a debt.'),
(8, 'Receive Debt', 'income', '2024-09-20T13:00 +08:00', 1, 'This category represents a transaction where other person settle a debt that they borrow from you.');
-- ('category_id', '5'),
-- ('category_name', 'Borrowing'),
-- ('catgeory_type', 'income'),
-- ('createdAt', '2024-09-20T13:00'),
-- ('isProtected', 'true');

-- INSERT INTO categories (category_id, category_name, category_type, created_at, is_protected)

-- -- ('6'),
-- -- ('category_name', 'Recieve Debt'),
-- -- ('catgeory_type', 'income'),
-- -- ('createdAt', '2024-09-20T13:00'),
-- -- ('isProtected', 'true');

---- BUDGET TABLE INSERTION ----
INSERT INTO budgets VALUES 
(1, 'Food', 200.00, '2024-09-20T13:00 +08:00', '2024-09-20T13:00 +08:00', '2024-09-01T00:00 +08:00', '2024-10-01T00:00 +08:00', 1),
(2, 'Leisure', 150.00, '2024-09-20T13:00 +08:00', '2024-09-20T13:00 +08:00', '2024-09-01T00:00 +08:00', '2024-10-01T00:00 +08:00', 2);

---- TRANSACTION TABLE AND DEBT TABLE INSERTION -----
-- One income transaction
-- transaction_id = 1, category_id = 5
INSERT INTO transactions (transaction_id, transaction_name, value, transaction_date, transaction_type, category_id)
VALUES (1, 'Gaji', 8.00, '2024-09-28T12:00 +08:00', 'income', 5);

-- One expense transaction
-- transaction_id = 2, category_id = 1
INSERT INTO transactions (transaction_id, transaction_name, value, transaction_date, transaction_type, category_id)
VALUES (2, 'Lunch', 8.00, '2024-09-28T14:00 +08:00', 'expense', 1);

-- One borrowing transaction with dateSettled = null
-- debt_id = 1, transaction_id (borrow) = 3, category_id (borrow) = 7
INSERT INTO debts (debt_id, people_name, expected_to_be_settled_date)
VALUES (1, 'Rusyaidi', '2024-10-03T12:00 +08:00');

INSERT INTO transactions (transaction_id, transaction_name, value, transaction_date, transaction_type, category_id, debt_id)
VALUES (3, 'Pinjam Syaidi', 10.00, '2024-09-25T12:00 +08:00', 'income', 7, 1);

-- One borrowing transaction with dateSettled != null and insert new paying debt transaction
-- debt_id = 2, transaction_id (borrow) = 3, category_id (borrow) = 7
-- transaction_id (pay_debt) = 4, category_id (pay debt) = 4
INSERT INTO debts (debt_id, people_name, expected_to_be_settled_date)
VALUES (2, 'Zarif', '2024-10-03T12:00 +08:00');

INSERT INTO transactions (transaction_id, transaction_name, value, transaction_date, transaction_type, category_id, debt_id)
VALUES (4, 'Pinjam Zarif', 10.00, '2024-09-25T12:00 +08:00', 'income', 7, 2);

INSERT INTO transactions (transaction_id, transaction_name, value, transaction_date, transaction_type, category_id, debt_id)
VALUES (5, 'Pinjam Zarif (Paid)', 10.00, '2024-09-25T18:00 +08:00', 'expense', 4, 2);

UPDATE debts
SET settled_date = '2024-09-25T18:00'
WHERE debt_id = 2;

-- One lending transaction with dateSettled = null
-- debt_id = 3, transaction_id (lend) = 6, category_id (lend) = 3
INSERT INTO debts (debt_id, people_name, expected_to_be_settled_date)
VALUES (3, 'Izzuddin', '2024-10-03T12:00 +08:00');

INSERT INTO transactions (transaction_id, transaction_name, value, transaction_date, transaction_type, category_id, debt_id)
VALUES (6, 'Idin Pinjam', 8.00, '2024-09-25T12:00 +08:00', 'expense', 3, 3);

-- One lending transaction with dateSettled != null and insert new receive debt transaction
-- debt_id = 4, transaction_id (lend) = 7, category_id (lend) = 3
-- transaction_id (receive debt) = 8, category_id (receive debt) = 8
INSERT INTO debts (debt_id, people_name, expected_to_be_settled_date)
VALUES (4, 'Yusmal', '2024-10-03T12:00 +08:00');

INSERT INTO transactions (transaction_id, transaction_name, value, transaction_date, transaction_type, category_id, debt_id)
VALUES (7, 'Yusmal Pinjam', 20.00, '2024-09-25T12:00 +08:00', 'expense', 3, 4);

INSERT INTO transactions (transaction_id, transaction_name, value, transaction_date, transaction_type, category_id, debt_id)
VALUES (8, 'Yusmal Pinjam (Paid)', 20.00, '2024-09-25T18:00 +08:00', 'income', 8, 4);

UPDATE debts
SET settled_date = '2024-09-25T18:00 +08:00'
WHERE debt_id = 4;
