CREATE TABLE MEMBER
(
    ID       NUMBER PRIMARY KEY,
    EMAIL    VARCHAR2(100) NOT NULL UNIQUE,
    NICKNAME VARCHAR2(30)  NOT NULL,
    HASHTAG  NUMBER(4)     NOT NULL,
    STATUS   VARCHAR2(100) NULL,
    DISSECT_NICKNAME VARCHAR2(100) NOT NULL
);

CREATE TABLE CHANNEL
(
    ID          NUMBER PRIMARY KEY,
    NAME        VARCHAR2(100) NOT NULL,
    THUMBNAIL   CLOB          NULL,
    INVITE_CODE VARCHAR2(100) NOT NULL
);

CREATE TABLE CHANNEL_MEMBER
(
    ID         NUMBER PRIMARY KEY,
    CHANNEL_ID NUMBER NOT NULL,
    MEMBER_ID  NUMBER NOT NULL,
    ROLE       VARCHAR2(20) DEFAULT 'guest' CHECK (ROLE IN ('owner', 'manager', 'guest')),
    CONSTRAINT CHANNEL_MEMBER_CHANNEL_ID_FK FOREIGN KEY (CHANNEL_ID) REFERENCES CHANNEL (ID) ON DELETE CASCADE,
    CONSTRAINT CHANNEL_MEMBER_MEMBER_ID_FK FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER (ID) ON DELETE CASCADE
);

CREATE TABLE TOPIC
(
    ID         NUMBER PRIMARY KEY,
    TITLE      VARCHAR2(100) NOT NULL,
    --     topic_group varchar2(100),
    CHANNEL_ID NUMBER        NOT NULL, -- id of the channel that references topic
    IS_RTC_CHANNEL NUMBER NOT NULL, -- 0 for text topic channel else rtc channel
    CONSTRAINT TOPIC_CHANNEL_ID_FK FOREIGN KEY (CHANNEL_ID) REFERENCES CHANNEL (ID) ON DELETE CASCADE
);

CREATE TABLE REFRESH_TOKEN
(
    ID          NUMBER PRIMARY KEY,
    MEMBER_ID   INTEGER       NOT NULL UNIQUE,
    TOKEN       VARCHAR2(255) NOT NULL,
    EXPIRE_DATE DATE          NOT NULL
);

CREATE TABLE MESSAGE_CHANNEL
(
    ID         NUMBER PRIMARY KEY,
    AUTHOR_ID  NUMBER         NOT NULL,
    CONTENT    VARCHAR2(1000) NOT NULL,
    CHANNEL_ID NUMBER         NOT NULL, -- id of the channel that references message
    TOPIC_ID   NUMBER         NOT NULL, -- id of the topic that references message
    CREATED_AT DATE           NOT NULL,
    UPDATED_AT DATE           NOT NULL,
    CONSTRAINT MESSAGE_CHANNEL_AUTHOR_ID_FK FOREIGN KEY (AUTHOR_ID) REFERENCES MEMBER (ID) ON DELETE CASCADE,
    CONSTRAINT MESSAGE_CHANNEL_CHANNEL_ID_FK FOREIGN KEY (CHANNEL_ID) REFERENCES CHANNEL (ID) ON DELETE CASCADE,
    CONSTRAINT MESSAGE_CHANNEL_TOPIC_ID_FK FOREIGN KEY (TOPIC_ID) REFERENCES TOPIC (ID) ON DELETE CASCADE
);

CREATE TABLE DIRECT_MESSAGE
(
    ID         NUMBER PRIMARY KEY,
    MEMBER_ID  NUMBER    NOT NULL,
    ANOTHER_ID NUMBER    NOT NULL,
    ACTIVE     NUMBER(1) NOT NULL,
    CONSTRAINT DIRECT_MESSAGE_MEMBER_ID_FK FOREIGN KEY (MEMBER_ID) REFERENCES MEMBER (ID) ON DELETE CASCADE,
    CONSTRAINT DIRECT_MESSAGE_ANOTHER_ID_FK FOREIGN KEY (ANOTHER_ID) REFERENCES MEMBER (ID) ON DELETE CASCADE
);

CREATE TABLE MESSAGE_DM
(
    ID          NUMBER PRIMARY KEY,
    AUTHOR_ID   NUMBER         NOT NULL,
    CONTENT     VARCHAR2(1000) NOT NULL,
    DM_ID       NUMBER         NOT NULL, -- id of the direct message topic that references message
    CREATED_AT  DATE           NOT NULL,
    UPDATED_AT  DATE           NOT NULL,
    CONSTRAINT  MESSAGE_DM_AUTHOR_ID_FK FOREIGN KEY (AUTHOR_ID) REFERENCES MEMBER (ID) ON DELETE CASCADE,
    CONSTRAINT  MESSAGE_DM_DM_ID_FK FOREIGN KEY (DM_ID) REFERENCES DIRECT_MESSAGE (ID) ON DELETE CASCADE
);

CREATE TABLE ATTACHMENT
(
    ID      NUMBER PRIMARY KEY,
    CONTENT BLOB
);

CREATE TABLE REQUEST_FRIEND
(
    ID      NUMBER PRIMARY KEY,
    FROM_ID NUMBER,
    TO_ID   NUMBER,
    CONSTRAINT REQUEST_FRIEND_FROM_ID_FK FOREIGN KEY (FROM_ID) REFERENCES MEMBER (ID) ON DELETE CASCADE,
    CONSTRAINT REQUEST_FRIEND_TO_ID_FK FOREIGN KEY (TO_ID) REFERENCES MEMBER (ID) ON DELETE CASCADE
);

CREATE TABLE FRIEND
(
    ID        NUMBER PRIMARY KEY,
    MY_ID     NUMBER,
    FRIEND_ID NUMBER,
    CONSTRAINT FRIEND_MY_ID_FK FOREIGN KEY (MY_ID) REFERENCES MEMBER (ID) ON DELETE CASCADE,
    CONSTRAINT FRIEND_FRIEND_ID_FK FOREIGN KEY (FRIEND_ID) REFERENCES MEMBER (ID) ON DELETE CASCADE
);

CREATE SEQUENCE MEMBER_SEQ START WITH 10000;

CREATE SEQUENCE CHANNEL_SEQ START WITH 10000;

CREATE SEQUENCE CHANNEL_MEMBER_SEQ START WITH 10000;

CREATE SEQUENCE TOPIC_SEQ START WITH 10000;

CREATE SEQUENCE DIRECT_MESSAGE_SEQ START WITH 10000;

CREATE SEQUENCE MESSAGE_CHANNEL_SEQ START WITH 10000;

CREATE SEQUENCE MESSAGE_DM_SEQ START WITH 10000;

CREATE SEQUENCE ATTACHMENT_SEQ START WITH 10000;

CREATE SEQUENCE TOKEN_SEQ START WITH 10000;

CREATE SEQUENCE REQUEST_FRIEND_SEQ START WITH 10000;

CREATE SEQUENCE FRIEND_SEQ START WITH 10000;