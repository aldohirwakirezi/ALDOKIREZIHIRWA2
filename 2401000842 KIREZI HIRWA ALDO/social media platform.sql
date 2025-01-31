show databases;
CREATE DATABASE social_mediaplatforms;

use social_mediaplatforms;
-- Create the User table
CREATE TABLE User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    DateCreated DATE NOT NULL
);

-- Create the Post table
CREATE TABLE PostS (
    PostID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Content TEXT NOT NULL,
    DatePosted DATE NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- Create the Comment table
CREATE TABLE Comments (
    PostID INT,
    UserID INT,
    Content TEXT NOT NULL,
    DateCommented DATE NOT NULL,
    FOREIGN KEY (PostID) REFERENCES Post(PostID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE Likes (
    PostID INT,
    UserID INT,
    DateLiked DATE NOT NULL,
    FOREIGN KEY (PostID) REFERENCES Post(PostID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- Create the Friendship table
CREATE TABLE Friendship (
    UserID1 INT,
    UserID2 INT,
    Status VARCHAR(50) DEFAULT 'Pending',
    PRIMARY KEY (UserID1, UserID2),
    FOREIGN KEY (UserID1) REFERENCES User(UserID),
    FOREIGN KEY (UserID2) REFERENCES User(UserID)
);
-- Insert  data into the User table
INSERT INTO user (Username, Email, Password, DateCreated)
VALUES 

       ('peter_paer', 'peer@email.com', 'peter_455_2', '2025-01-02'),
       ('alain_muku', 'muku@email.com', '456_56768_3', '2025-01-03'),
       ('kagame_paul', 'kagame@email.com', '5676er_4', '2025-01-04');

-- Insert  data into the Post table
INSERT INTO Posts (postID, Content, DatePosted)
VALUES 
    (1, 'This is my first post!', '2025-01-01'),
    (2, 'Loving this social media platform!', '2025-01-02'),
    (3, 'Here is my post on social media.', '2025-01-03'),
    (4, 'Hello world!', '2025-01-04');

-- Insert data into the Comment table
INSERT INTO Comments (PostID, UserID, Content, DateCommented) 
VALUES
    (1, 2, 'Great post', '2025-01-01'),
    (2, 1, 'Thanks for sharing!', '2025-01-02'),
    (3, 4, 'Nice post', '2025-01-03');

SELECT AVG(CommentCount) 
FROM (SELECT PostID, COUNT(*) AS CommentCount 
      FROM Comments 
      GROUP BY PostID) AS PostComments;

-- Insert sample data into the Like table
INSERT INTO Likes (PostID, UserID, DateLiked)
VALUES 
    (1, 3, '2025-01-01'),
    (2, 4, '2025-01-02'),
    (3, 1, '2025-01-03'),
    (4, 2, '2025-01-04');


INSERT INTO Friendship (UserID1, UserID2, Status)
VALUES 
    (1, 2, 'Accepted'),
    (1, 3, 'Pending'),
    (2, 3, 'Accepted'),
    (3, 4, 'Pending');
    
SELECT * FROM User WHERE UserID = 1;

show tables;

SELECT COUNT(*) 
FROM Posts 
WHERE UserID = 1;


CREATE VIEW UserPosts AS
SELECT PostID, Content, DatePosted
FROM Posts
WHERE UserID = 1;
SELECT AVG(CommentCount) 
FROM (SELECT PostID, COUNT(*) AS CommentCount 
      FROM Comments 
      GROUP BY PostID) AS PostComments;
      
      SELECT SUM(1) 
FROM Likes 
WHERE PostID = 1;

CREATE VIEW PostLikes AS
SELECT P.PostID, P.Content, COUNT(L.LikeID) AS LikeCount
FROM Posts P
LEFT JOIN Likes L ON P.PostID = L.PostID
GROUP BY P.PostID;
DELIMITER $$  

CREATE PROCEDURE AddUser (
    IN p_Username VARCHAR(50), 
    IN p_Email VARCHAR(100), 
    IN p_Password VARCHAR(255)
)
BEGIN
    INSERT INTO Users (username, Email, Password, DateCreated) 
    VALUES (p_Username, p_Email, p_Password, NOW());  
END $$  

DELIMITER ;  
  
SELECT AVG(Email) AS avg_Email FROM User;
SELECT SUM(Email) AS total_Email FROM User;

SELECT COUNT(*) AS total_posts FROM Posts;
DELETE FROM Posts 
WHERE PostID = 1;
SELECT COUNT(*) AS total_comments_for_post FROM Comments WHERE PostID = 1;
SELECT AVG(LikesCount) AS avg_likes_per_comment FROM Comments;
DELIMITER $$

CREATE TRIGGER after_post_insert
AFTER INSERT ON Posts
FOR EACH ROW
BEGIN
    INSERT INTO PostLog (Action, PostID, ActionTime)
    VALUES ('INSERT', NEW.PostID, NOW());
END $$

DELIMITER ;



CREATE TABLE Post_Changes (
    change_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    old_content TEXT,
    new_content TEXT,
    change_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);
DELIMITER $$

CREATE TRIGGER after_comment_insert
AFTER INSERT ON Comments
FOR EACH ROW
BEGIN
    INSERT INTO CommentLog (Action, CommentID, PostID, ActionTime)
    VALUES ('INSERT', NEW.CommentID, NEW.PostID, NOW());
END $$

DELIMITER ;
