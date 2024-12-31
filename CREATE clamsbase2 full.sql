/*
Created: 11/19/2013
Modified: 10/31/2023
Model: MACEBASE2
Database: Oracle 11g Release 2
*/




-- Create sequences section -------------------------------------------------

CREATE SEQUENCE clamsbase2.BASKET_ID_SEQ
 INCREMENT BY 1
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 CACHE 20
/

CREATE SEQUENCE clamsbase2.SAMPLE_ID_SEQ
 INCREMENT BY 1
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 CACHE 20
/

CREATE SEQUENCE clamsbase2.SPECIMEN_ID_SEQ
 INCREMENT BY 1
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 CACHE 20
/

CREATE SEQUENCE clamsbase2.PROT_SPP_ID_SEQ
 INCREMENT BY 1
 START WITH 1
 NOMAXVALUE
 MINVALUE 1
 CACHE 20
/

-- Create tables section -------------------------------------------------

-- Table clamsbase2.SHIPS

CREATE TABLE clamsbase2.SHIPS(
  ship Number(4,0) NOT NULL,
  name Varchar2(128 ) NOT NULL,
  description Varchar2(2048 ),
  active Number(1,0) NOT NULL
)
/

-- Add keys for table clamsbase2.SHIPS

ALTER TABLE clamsbase2.SHIPS ADD CONSTRAINT ship_pk PRIMARY KEY (ship)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.SHIPS IS 'ship describes the platform the sonar is operated from/mounted to.'
/

-- Table clamsbase2.surveys

CREATE TABLE clamsbase2.surveys(
  survey Number(8,0) NOT NULL,
  ship Number(4,0) NOT NULL,
  name Varchar2(512 ) NOT NULL,
  chief_scientist Varchar2(64 ) NOT NULL,
  start_date Date NOT NULL,
  end_date Date NOT NULL,
  start_port Varchar2(256 ) NOT NULL,
  end_port Varchar2(256 ) NOT NULL,
  region Varchar2(128 ),
  sea_area Varchar2(128 ),
  abstract Varchar2(4000 )
)
/

-- Add keys for table clamsbase2.surveys

ALTER TABLE clamsbase2.surveys ADD CONSTRAINT survey_pk PRIMARY KEY (survey,ship)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.surveys IS 'Survey provides basic information regarding the operation performed to collect our data. This includes a unique survey number, the platform (ship) that was used, start and end dates, start and end ports, the IHO sea area, and many other parameters such as description that can be stored as parameter/parameter value pairs.'
/
COMMENT ON COLUMN clamsbase2.surveys.survey IS 'The survey code for the survey. Typically YYYYSS where YYYY is the 4 digit year and SS is a 2 digit survey number.'
/
COMMENT ON COLUMN clamsbase2.surveys.ship IS 'The vessel code for the ship this survey was conducted on.'
/
COMMENT ON COLUMN clamsbase2.surveys.name IS 'The name of the survey. Typically something like 2015 Bering Sea EIT survey or 2014 Shelikof Straight EIT survey.'
/
COMMENT ON COLUMN clamsbase2.surveys.chief_scientist IS 'The name of the survey chief scientist.'
/
COMMENT ON COLUMN clamsbase2.surveys.start_date IS 'The starting date of the survey'
/
COMMENT ON COLUMN clamsbase2.surveys.end_date IS 'The ending date of the survey'
/
COMMENT ON COLUMN clamsbase2.surveys.start_port IS 'The port the survey vessel departed from to start the survey'
/
COMMENT ON COLUMN clamsbase2.surveys.end_port IS 'The port the survey vessel ends the survey at.'
/
COMMENT ON COLUMN clamsbase2.surveys.sea_area IS 'The IHO sea area the majority of the survey was performed in. '
/
COMMENT ON COLUMN clamsbase2.surveys.abstract IS 'A full description of the survey purpose and methods suitable for use in discovery level metadata.'
/

-- Table clamsbase2.survey_data

CREATE TABLE clamsbase2.survey_data(
  survey Number(8,0) NOT NULL,
  ship Number(4,0) NOT NULL,
  survey_parameter Varchar2(64 ) NOT NULL,
  parameter_value Varchar2(4000 ) NOT NULL
)
/

-- Add keys for table clamsbase2.survey_data

ALTER TABLE clamsbase2.survey_data ADD CONSTRAINT survey_parms_pk PRIMARY KEY (survey,survey_parameter,ship)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.survey_data IS 'Stores various parameters related to a survey such as description, chief scientist, etc.'
/

-- Table clamsbase2.survey_parameters

CREATE TABLE clamsbase2.survey_parameters(
  survey_parameter Varchar2(64 ) NOT NULL,
  parameter_type Varchar2(32 ) NOT NULL,
  PARAMETER_UNIT Varchar2(32 ) NOT NULL,
  description Varchar2(4000 ) NOT NULL
)
/

-- Add keys for table clamsbase2.survey_parameters

ALTER TABLE clamsbase2.survey_parameters ADD CONSTRAINT survey_parms_type_pk PRIMARY KEY (survey_parameter)
/

-- Table clamsbase2.APPLICATION_CONFIGURATION

CREATE TABLE clamsbase2.APPLICATION_CONFIGURATION(
  PARAMETER Varchar2(50 ) CONSTRAINT SYS_C00460293 NOT NULL,
  PARAMETER_VALUE Varchar2(500 ) CONSTRAINT SYS_C00460294 NOT NULL,
  DESCRIPTION Varchar2(500 )
)
/

-- Add keys for table clamsbase2.APPLICATION_CONFIGURATION

ALTER TABLE clamsbase2.APPLICATION_CONFIGURATION ADD CONSTRAINT APP_CONFIG_PK PRIMARY KEY (PARAMETER)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.APPLICATION_CONFIGURATION IS 'Stores general parameters applied to all workstations - used by the CLAMS application.'
/
COMMENT ON COLUMN clamsbase2.APPLICATION_CONFIGURATION.PARAMETER IS 'The parameter name. For example: MaxBasketWt'
/
COMMENT ON COLUMN clamsbase2.APPLICATION_CONFIGURATION.PARAMETER_VALUE IS 'The parameter value. For example: 40'
/

-- Table clamsbase2.BASKETS

CREATE TABLE clamsbase2.BASKETS(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  EVENT_ID Number(6,2) NOT NULL,
  SAMPLE_ID Number(6,0) CONSTRAINT SYS_C00460288 NOT NULL,
  BASKET_ID Number(10,0) CONSTRAINT SYS_C00460287 NOT NULL,
  BASKET_TYPE Varchar2(25 ) CONSTRAINT SYS_C00460289 NOT NULL,
  COUNT Number(10,0),
  WEIGHT Number(10,3) CONSTRAINT SYS_C00460290 NOT NULL,
  DEVICE_ID Number(4,0) CONSTRAINT SYS_C00460291 NOT NULL,
  TIME_STAMP Date DEFAULT SYSDATE CONSTRAINT SYS_C00460292 NOT NULL
)
/

-- Add keys for table clamsbase2.BASKETS

ALTER TABLE clamsbase2.BASKETS ADD CONSTRAINT BASKET_PK PRIMARY KEY (ship,survey,EVENT_ID,SAMPLE_ID,BASKET_ID)
/

-- Create triggers for table clamsbase2.BASKETS

CREATE OR REPLACE TRIGGER clamsbase2.BASKET_BEF_UPD_ROW
  BEFORE UPDATE
  ON clamsbase2.BASKETS
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN SELECT SYSDATE INTO :new.Time_Stamp FROM dual; END BASKET_BEF_UPD_ROW;
/

CREATE OR REPLACE TRIGGER clamsbase2.BASKET_BEF_INS_ROW
  BEFORE INSERT
  ON clamsbase2.BASKETS
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN SELECT BASKET_ID_SEQ.NextVal INTO :new.Basket_Id FROM dual; END BASKET_BEF_INS_ROW;
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.BASKETS IS 'BASKET describes parts of a sample. The table name implies we expect you to use baskets to hold these parts, but you can also use tubs, barrels, trays, or test tubes to hold your bits of a sample. Baskets associated with a sample all contain the same thing.'
/
COMMENT ON COLUMN clamsbase2.BASKETS.EVENT_ID IS 'The event ID of the sample this basket is associated with.'
/
COMMENT ON COLUMN clamsbase2.BASKETS.SAMPLE_ID IS 'The sample ID of the sample this basket is taken from.'
/
COMMENT ON COLUMN clamsbase2.BASKETS.BASKET_ID IS 'A unique number identifying this basket for this sample. Baskets can be reused between samples and partitions.'
/
COMMENT ON COLUMN clamsbase2.BASKETS.COUNT IS 'The number of individual organisms in this basket (if counted).'
/
COMMENT ON COLUMN clamsbase2.BASKETS.WEIGHT IS 'The weight of the basket.'
/
COMMENT ON COLUMN clamsbase2.BASKETS.DEVICE_ID IS 'The device ID of the scale used to weight the basket.'
/
COMMENT ON COLUMN clamsbase2.BASKETS.TIME_STAMP IS 'The time the basket was weighed.'
/

-- Table clamsbase2.BASKET_TYPES

CREATE TABLE clamsbase2.BASKET_TYPES(
  BASKET_TYPE Varchar2(25 ) CONSTRAINT SYS_C00460237 NOT NULL,
  DESCRIPTION Varchar2(500 ) CONSTRAINT SYS_C00460238 NOT NULL
)
/

-- Add keys for table clamsbase2.BASKET_TYPES

ALTER TABLE clamsbase2.BASKET_TYPES ADD CONSTRAINT BASKET_TYPES_PK PRIMARY KEY (BASKET_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.BASKET_TYPES IS 'Basket Types defines the valid processing actions for a basket sample.'
/
COMMENT ON COLUMN clamsbase2.BASKET_TYPES.BASKET_TYPE IS 'The name of the sample type. Examples are Count, Subsample, Toss, etc.'
/
COMMENT ON COLUMN clamsbase2.BASKET_TYPES.DESCRIPTION IS 'A description of the basket type.'
/

-- Table clamsbase2.CONDITIONALS

CREATE TABLE clamsbase2.CONDITIONALS(
  CONDITIONAL Varchar2(50 ) CONSTRAINT SYS_C00460321 NOT NULL,
  PROTOCOL_NAME Varchar2(50 ) CONSTRAINT SYS_C00460322 NOT NULL
)
/

-- Add keys for table clamsbase2.CONDITIONALS

ALTER TABLE clamsbase2.CONDITIONALS ADD CONSTRAINT CONDITIONALS_PK PRIMARY KEY (CONDITIONAL,PROTOCOL_NAME)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.CONDITIONALS IS 'Conditionals maps conditionals (a check to see if a condition is met) to a measurement type and protocol.'
/
COMMENT ON COLUMN clamsbase2.CONDITIONALS.CONDITIONAL IS 'Foreign Key - see comments on parent VALIDATION_DEFINITIONS.Validation.'
/
COMMENT ON COLUMN clamsbase2.CONDITIONALS.PROTOCOL_NAME IS 'Foreign Key - see comments on parent SPECIMEN_PROTOCOL.Protocol_Name.'
/

-- Table clamsbase2.CONDITIONAL_DEFINITIONS

CREATE TABLE clamsbase2.CONDITIONAL_DEFINITIONS(
  CONDITIONAL Varchar2(50 ) CONSTRAINT SYS_C00460318 NOT NULL,
  MODULE Varchar2(50 ) CONSTRAINT SYS_C00460319 NOT NULL,
  DESCRIPTION Varchar2(2000 ) CONSTRAINT SYS_C00460320 NOT NULL
)
/

-- Add keys for table clamsbase2.CONDITIONAL_DEFINITIONS

ALTER TABLE clamsbase2.CONDITIONAL_DEFINITIONS ADD CONSTRAINT CONDITIONAL_DEF_PK PRIMARY KEY (CONDITIONAL)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.CONDITIONAL_DEFINITIONS IS 'Conditional Definitions maps conditionals (a check to see if a condition is met) to the python module that is called to perform the conditional check.'
/
COMMENT ON COLUMN clamsbase2.CONDITIONAL_DEFINITIONS.CONDITIONAL IS 'The name of the conditional. Must be unique.'
/
COMMENT ON COLUMN clamsbase2.CONDITIONAL_DEFINITIONS.MODULE IS 'Module contains the name of the Python module that is called to perform this conditional check.'
/
COMMENT ON COLUMN clamsbase2.CONDITIONAL_DEFINITIONS.DESCRIPTION IS 'A description of the conditional.'
/

-- Table clamsbase2.DEVICES

CREATE TABLE clamsbase2.DEVICES(
  DEVICE_ID Number(4,0) CONSTRAINT SYS_C00460160 NOT NULL,
  DEVICE_NAME Varchar2(50 ) CONSTRAINT SYS_C00460161 NOT NULL,
  MODEL Varchar2(50 ),
  SERIAL_NUMBER Varchar2(30 ),
  DESCRIPTION Varchar2(2000 ),
  ACTIVE Number(1,0)
)
/

-- Add keys for table clamsbase2.DEVICES

ALTER TABLE clamsbase2.DEVICES ADD CONSTRAINT DEVICE_PK PRIMARY KEY (DEVICE_ID)
/

ALTER TABLE clamsbase2.DEVICES ADD CONSTRAINT DEVICE_UNQ UNIQUE (DEVICE_NAME,MODEL,SERIAL_NUMBER)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.DEVICES IS 'Device links sampling devices and instruments with a device ID.'
/
COMMENT ON COLUMN clamsbase2.DEVICES.DEVICE_ID IS 'A unique number identifying this input device or instrument.'
/
COMMENT ON COLUMN clamsbase2.DEVICES.DEVICE_NAME IS 'The name of the device e.g. Length Board, Basket Scale, GPS, etc.'
/
COMMENT ON COLUMN clamsbase2.DEVICES.MODEL IS 'The make and model of the device.'
/
COMMENT ON COLUMN clamsbase2.DEVICES.SERIAL_NUMBER IS 'The manufacturer serial number or other unique ID of the device.'
/
COMMENT ON COLUMN clamsbase2.DEVICES.DESCRIPTION IS 'A description of the device or the devices typical deployment location.'
/

-- Table clamsbase2.DEVICE_CONFIGURATION

CREATE TABLE clamsbase2.DEVICE_CONFIGURATION(
  DEVICE_ID Number(4,0) CONSTRAINT SYS_C00460165 NOT NULL,
  DEVICE_PARAMETER Varchar2(50 ) CONSTRAINT SYS_C00460166 NOT NULL,
  PARAMETER_VALUE Varchar2(250 )
)
/

-- Add keys for table clamsbase2.DEVICE_CONFIGURATION

ALTER TABLE clamsbase2.DEVICE_CONFIGURATION ADD CONSTRAINT DEVCONFIG_PK PRIMARY KEY (DEVICE_ID,DEVICE_PARAMETER)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.DEVICE_CONFIGURATION IS 'Stores configuration parameter/value pairs for devices. An example would be a parameter of baud_rate and a value of 9600'
/
COMMENT ON COLUMN clamsbase2.DEVICE_CONFIGURATION.DEVICE_ID IS 'Foreign Key - see comments on parent DEVICE.Device_Id.'
/
COMMENT ON COLUMN clamsbase2.DEVICE_CONFIGURATION.DEVICE_PARAMETER IS 'Foreign Key - see comments on parent DEVICE_PARAMETERS.Device_Parameter.'
/
COMMENT ON COLUMN clamsbase2.DEVICE_CONFIGURATION.PARAMETER_VALUE IS 'The value associated with this parameter.'
/

-- Table clamsbase2.DEVICE_INTERFACES

CREATE TABLE clamsbase2.DEVICE_INTERFACES(
  DEVICE_INTERFACE Varchar2(30 ) CONSTRAINT SYS_C00460169 NOT NULL,
  DESCRIPTION Varchar2(256 ) CONSTRAINT SYS_C00460170 NOT NULL
)
/

-- Add keys for table clamsbase2.DEVICE_INTERFACES

ALTER TABLE clamsbase2.DEVICE_INTERFACES ADD CONSTRAINT DEVINTERFACES_PK PRIMARY KEY (DEVICE_INTERFACE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.DEVICE_INTERFACES IS 'Device Interfaces defines the general connection methods for devices. This informs CLAMS as to which acquisition package to use for a specific device.'
/
COMMENT ON COLUMN clamsbase2.DEVICE_INTERFACES.DEVICE_INTERFACE IS 'A connection method. These methods are general, defining a broad technology or interface. Examples are SERIAL, SOFTWARE, NETWORK, SCS.'
/
COMMENT ON COLUMN clamsbase2.DEVICE_INTERFACES.DESCRIPTION IS 'Text describing the interface.'
/

-- Table clamsbase2.DEVICE_PARAMETERS

CREATE TABLE clamsbase2.DEVICE_PARAMETERS(
  DEVICE_PARAMETER Varchar2(50 ) CONSTRAINT SYS_C00460162 NOT NULL,
  DATA_TYPE Varchar2(10 ) CONSTRAINT SYS_C00460163 NOT NULL,
  DESCRIPTION Varchar2(250 ) CONSTRAINT SYS_C00460164 NOT NULL
)
/

-- Add keys for table clamsbase2.DEVICE_PARAMETERS

ALTER TABLE clamsbase2.DEVICE_PARAMETERS ADD CONSTRAINT DEVICE_PARAMETERS_PK PRIMARY KEY (DEVICE_PARAMETER)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.DEVICE_PARAMETERS IS 'Device Parameters defines the configuration parameters for sampling devices. Examples are baud_rate, serial_port, etc.'
/
COMMENT ON COLUMN clamsbase2.DEVICE_PARAMETERS.DEVICE_PARAMETER IS 'The name of the device parameter. Examples are baud_rate, parity, serial_port, etc.'
/
COMMENT ON COLUMN clamsbase2.DEVICE_PARAMETERS.DATA_TYPE IS 'Specifies if the data is INTEGER, FLOAT, or STRING. Can be used to convert the internal string representation of the data to the original data type.'
/
COMMENT ON COLUMN clamsbase2.DEVICE_PARAMETERS.DESCRIPTION IS 'A description of the device parameter'
/

-- Table clamsbase2.GEAR

CREATE TABLE clamsbase2.GEAR(
  GEAR Varchar2(50 ) CONSTRAINT SYS_C00460198 NOT NULL,
  GEAR_TYPE Varchar2(50 ) CONSTRAINT SYS_C00460199 NOT NULL,
  GEAR_CODE Number(3,0) CONSTRAINT SYS_C00460200 NOT NULL,
  DESCRIPTION Varchar2(2000 ) CONSTRAINT SYS_C00460201 NOT NULL,
  GEAR_GUI_ORDER Number(2,0) CONSTRAINT SYS_C00460202 NOT NULL,
  ACTIVE Number(1,0) CONSTRAINT SYS_C00460203 NOT NULL
)
/

-- Add keys for table clamsbase2.GEAR

ALTER TABLE clamsbase2.GEAR ADD CONSTRAINT GEAR_PK PRIMARY KEY (GEAR)
/

ALTER TABLE clamsbase2.GEAR ADD CONSTRAINT GEAR_CODE_UNQ UNIQUE (GEAR_CODE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.GEAR IS 'Gear contains the descriptions of potential sampling gear used during an event. The gear codes have been taken from the RACE code tables but any code can be used as long as it is unique within CLAMS and meaningful to you.'
/
COMMENT ON COLUMN clamsbase2.GEAR.GEAR IS 'The unique name of the gear.'
/
COMMENT ON COLUMN clamsbase2.GEAR.GEAR_TYPE IS 'The general class of gear this gear belongs to. For example plankton net'
/
COMMENT ON COLUMN clamsbase2.GEAR.GEAR_CODE IS 'The RACE gear code.'
/
COMMENT ON COLUMN clamsbase2.GEAR.DESCRIPTION IS 'A description of the gear.'
/
COMMENT ON COLUMN clamsbase2.GEAR.GEAR_GUI_ORDER IS 'Used by CLAMS application to order GUI elements.'
/
COMMENT ON COLUMN clamsbase2.GEAR.ACTIVE IS 'Used by CLAMS to show or hide gear in the GUI. Set active=1 to show the gear, set it to 0 to hide it in the GUI.'
/

-- Table clamsbase2.GEAR_ACCESSORY

CREATE TABLE clamsbase2.GEAR_ACCESSORY(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  EVENT_ID Number(6,2) CONSTRAINT SYS_C00460230 NOT NULL,
  GEAR_ACCESSORY Varchar2(25 ) CONSTRAINT SYS_C00460231 NOT NULL,
  GEAR_ACCESSORY_OPTION Varchar2(50 ) CONSTRAINT SYS_C00460232 NOT NULL
)
/

-- Add keys for table clamsbase2.GEAR_ACCESSORY

ALTER TABLE clamsbase2.GEAR_ACCESSORY ADD CONSTRAINT GEAR_ACC_PK PRIMARY KEY (EVENT_ID,GEAR_ACCESSORY,GEAR_ACCESSORY_OPTION,survey,ship)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.GEAR_ACCESSORY IS 'GEAR_ACCESSORY stores information regarding optional or variable accessories that were attached to sampling gear during an event. For example, an accessory could be "Tomweights" and the option might be "500" which would specify that the gear for this event was equipped with 500 lb tomweights.'
/
COMMENT ON COLUMN clamsbase2.GEAR_ACCESSORY.EVENT_ID IS 'The event ID this gear accessory record is related to.'
/

-- Table clamsbase2.GEAR_ACCESSORY_OPTIONS

CREATE TABLE clamsbase2.GEAR_ACCESSORY_OPTIONS(
  GEAR_ACCESSORY Varchar2(25 ) CONSTRAINT SYS_C00460225 NOT NULL,
  GEAR_ACCESSORY_OPTION Varchar2(50 ) CONSTRAINT SYS_C00460226 NOT NULL,
  ACTIVE Number(1,0) CONSTRAINT SYS_C00460227 NOT NULL
)
/

-- Add keys for table clamsbase2.GEAR_ACCESSORY_OPTIONS

ALTER TABLE clamsbase2.GEAR_ACCESSORY_OPTIONS ADD CONSTRAINT GEAR_ACC_OPTIONS_PK PRIMARY KEY (GEAR_ACCESSORY,GEAR_ACCESSORY_OPTION)
/

-- Table and Columns comments section

COMMENT ON COLUMN clamsbase2.GEAR_ACCESSORY_OPTIONS.ACTIVE IS 'A 1 marks the gear accessory option as active and the name will be listed in the CLAMS application GUI. 0 will mark an entry as inactive and it will not appear in the GUI.'
/

-- Table clamsbase2.GEAR_ACCESSORY_TYPES

CREATE TABLE clamsbase2.GEAR_ACCESSORY_TYPES(
  GEAR_ACCESSORY Varchar2(25 ) CONSTRAINT SYS_C00460223 NOT NULL,
  PARAMETER_TYPE Varchar2(32 ) NOT NULL,
  PARAMETER_UNIT Varchar2(32 ) NOT NULL,
  DESCRIPTION Varchar2(2000 )
)
/

-- Add keys for table clamsbase2.GEAR_ACCESSORY_TYPES

ALTER TABLE clamsbase2.GEAR_ACCESSORY_TYPES ADD CONSTRAINT GEAR_ACC_TYPES_PK PRIMARY KEY (GEAR_ACCESSORY)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.GEAR_ACCESSORY_TYPES IS 'GEAR_ACCESSORY_TYPES stores the types of accessories that can be attached to gear to modify the performance of the gear. Examples are doors, tomweights, flow meters, SBE or CTD devices. This could also be used to capture other gear configuration options such as bridal lengths, number and or type of floats, etc.'
/

-- Table clamsbase2.GEAR_OPTIONS

CREATE TABLE clamsbase2.GEAR_OPTIONS(
  GEAR Varchar2(50 ),
  EVENT_TYPE Number(4,1),
  PERFORMANCE_CODE Number(4,2),
  GEAR_ACCESSORY Varchar2(25 ),
  EVENT_PARAMETER Varchar2(50 ),
  BASKET_TYPE Varchar2(25 ),
  PARTITION Varchar2(50 ),
  HAULTYPE_GUI_ORDER Number(2,0),
  PERF_GUI_ORDER Number(2,0)
)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.GEAR_OPTIONS IS 'Gear Options links gear types to valid options presented in the CLAMS GUI.'
/

-- Table clamsbase2.GEAR_PARTITIONS

CREATE TABLE clamsbase2.GEAR_PARTITIONS(
  PARTITION Varchar2(50 ) CONSTRAINT SYS_C00460206 NOT NULL,
  PARTITION_TYPE Varchar2(50 ) CONSTRAINT SYS_C00460207 NOT NULL,
  DESCRIPTION Varchar2(2000 ) CONSTRAINT SYS_C00460208 NOT NULL
)
/

-- Add keys for table clamsbase2.GEAR_PARTITIONS

ALTER TABLE clamsbase2.GEAR_PARTITIONS ADD CONSTRAINT GEAR_PARTS_PK PRIMARY KEY (PARTITION)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.GEAR_PARTITIONS IS 'Gear partitions defines parts of your sampling gear that capture and retain organisms that you will sample. Partitions could be defined for individual Niskin bottles on a rosette, the individual nets on a MOCNESS, individual cod ends on a trawl equipped with a MOCC, a single cod end on a trawl or Methot, or pocket nets on a larger trawl.'
/
COMMENT ON COLUMN clamsbase2.GEAR_PARTITIONS.PARTITION IS 'A unique name identifying the partition, for example MOCC-CodEnd-1'
/
COMMENT ON COLUMN clamsbase2.GEAR_PARTITIONS.PARTITION_TYPE IS 'The type of this partition. For example "Catch" partitions contain catch that was processed with CLAMS. "Image" partitions are collections of data collected from images taken in-situ that are analysed outside of CLAMS whos results are then stored in CLAMS.'
/
COMMENT ON COLUMN clamsbase2.GEAR_PARTITIONS.DESCRIPTION IS 'A descritpion of the partition type, for example: The first cod end of the MOCC.'
/

-- Table clamsbase2.GEAR_PARTITION_TYPES

CREATE TABLE clamsbase2.GEAR_PARTITION_TYPES(
  PARTITION_TYPE Varchar2(50 ) CONSTRAINT SYS_C00460204 NOT NULL,
  DESCRIPTION Varchar2(1024 ) CONSTRAINT SYS_C00460205 NOT NULL
)
/

-- Add keys for table clamsbase2.GEAR_PARTITION_TYPES

ALTER TABLE clamsbase2.GEAR_PARTITION_TYPES ADD CONSTRAINT GEAR_PAR_TYPES_PK PRIMARY KEY (PARTITION_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.GEAR_PARTITION_TYPES IS 'Defines the sampling gear partition types. Partition types are general classes that a partition is associated with. CLAMS uses this information to present the user with different options during processing based on the partitions on their gear and the partition types.'
/
COMMENT ON COLUMN clamsbase2.GEAR_PARTITION_TYPES.PARTITION_TYPE IS 'A unique name identifying the partition type, for example, Catch.'
/
COMMENT ON COLUMN clamsbase2.GEAR_PARTITION_TYPES.DESCRIPTION IS 'A descritpion of the partition type, for example for Catch the description could be: Contains organisms captured by the gear which should be sampled.'
/

-- Table clamsbase2.GEAR_TYPES

CREATE TABLE clamsbase2.GEAR_TYPES(
  GEAR_TYPE Varchar2(50 ) CONSTRAINT SYS_C00460196 NOT NULL,
  DESCRIPTION Varchar2(2000 ) CONSTRAINT SYS_C00460197 NOT NULL,
  retains_catch Number(1,0) DEFAULT 1 NOT NULL
)
/

-- Add keys for table clamsbase2.GEAR_TYPES

ALTER TABLE clamsbase2.GEAR_TYPES ADD CONSTRAINT GEAR_TYPES_PK PRIMARY KEY (GEAR_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.GEAR_TYPES IS 'Gear Types contains the descriptions of the general classes of sampling gear.'
/
COMMENT ON COLUMN clamsbase2.GEAR_TYPES.GEAR_TYPE IS 'The name of the gear class. Examples are '
/
COMMENT ON COLUMN clamsbase2.GEAR_TYPES.DESCRIPTION IS 'A description of the gear.'
/
COMMENT ON COLUMN clamsbase2.GEAR_TYPES.retains_catch IS 'Set to 1 to indicate that this gear retains catch that will be processed in CLAMS.'
/

-- Table clamsbase2.EVENTS

CREATE TABLE clamsbase2.EVENTS(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  EVENT_ID Number(6,2) CONSTRAINT SYS_C00460211 NOT NULL,
  GEAR Varchar2(50 ) CONSTRAINT SYS_C00460212 NOT NULL,
  EVENT_TYPE Number(4,1) CONSTRAINT SYS_C00460213 NOT NULL,
  PERFORMANCE_CODE Number(4,2) CONSTRAINT SYS_C00460214 NOT NULL,
  SCIENTIST Varchar2(64 ) CONSTRAINT SYS_C00460215 NOT NULL,
  COMMENTS Varchar2(4000 )
)
/

-- Add keys for table clamsbase2.EVENTS

ALTER TABLE clamsbase2.EVENTS ADD CONSTRAINT EVENTS_PK PRIMARY KEY (ship,survey,EVENT_ID)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.EVENTS IS 'Events describes a sampling operation. This table is used to store any sampling operation you may perform like a CTD cast, camera drop or tow, Methot, etc.'
/
COMMENT ON COLUMN clamsbase2.EVENTS.GEAR IS 'Foreign Key - see comments on parent GEAR.Gear.'
/
COMMENT ON COLUMN clamsbase2.EVENTS.EVENT_TYPE IS 'Foreign Key - see comments on parent EVENT_TYPES.event_type.'
/
COMMENT ON COLUMN clamsbase2.EVENTS.PERFORMANCE_CODE IS 'Foreign Key - see comments on parent SAMPLING_EVENT_PERFORMANCE.Performance_Code.'
/
COMMENT ON COLUMN clamsbase2.EVENTS.SCIENTIST IS 'Foreign Key - see comments on parent PERSONNEL.Scientist.'
/

-- Table clamsbase2.EVENT_DATA

CREATE TABLE clamsbase2.EVENT_DATA(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  EVENT_ID Number(6,2) CONSTRAINT SYS_C00460218 NOT NULL,
  PARTITION Varchar2(50 ) CONSTRAINT SYS_C00460219 NOT NULL,
  EVENT_PARAMETER Varchar2(50 ) CONSTRAINT SYS_C00460220 NOT NULL,
  PARAMETER_VALUE Varchar2(250 ) NOT NULL
)
/

-- Add keys for table clamsbase2.EVENT_DATA

ALTER TABLE clamsbase2.EVENT_DATA ADD CONSTRAINT EVENT_DATA_PK PRIMARY KEY (ship,survey,EVENT_ID,PARTITION,EVENT_PARAMETER)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.EVENT_DATA IS 'EVENT_DATA stores data such as starting and ending postion, temperature, windspeed, etc. associated with a sampling event.'
/
COMMENT ON COLUMN clamsbase2.EVENT_DATA.EVENT_ID IS 'The event this parameter applies to.'
/
COMMENT ON COLUMN clamsbase2.EVENT_DATA.PARTITION IS 'The Partition this parameter applies to.'
/
COMMENT ON COLUMN clamsbase2.EVENT_DATA.EVENT_PARAMETER IS 'Event Parameter identifies the data (the parameter_value) that is associated with this record for this sampling event. Additional information such as the data type (integer, string, float) and the parameter type descri[ption can be found in the event_parameters table.'
/
COMMENT ON COLUMN clamsbase2.EVENT_DATA.PARAMETER_VALUE IS 'The data associated with this ship, survey, haul, Partition and haul parameter.'
/

-- Table clamsbase2.EVENT_PARAMETERS

CREATE TABLE clamsbase2.EVENT_PARAMETERS(
  EVENT_PARAMETER Varchar2(50 ) CONSTRAINT SYS_C00460182 NOT NULL,
  parameter_type Varchar2(32 ) NOT NULL,
  PARAMETER_UNIT Varchar2(32 ) NOT NULL,
  DESCRIPTION Varchar2(250 ) CONSTRAINT SYS_C00460184 NOT NULL,
  SOURCE Varchar2(25 ) CONSTRAINT SYS_C00460185 NOT NULL,
  SCS_PARAMETER_NAME Varchar2(50 )
)
/

-- Add keys for table clamsbase2.EVENT_PARAMETERS

ALTER TABLE clamsbase2.EVENT_PARAMETERS ADD CONSTRAINT HAUL_PARMS_PK PRIMARY KEY (EVENT_PARAMETER)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.EVENT_PARAMETERS IS 'EVENT_PARAMETERS contains descriptions of the types of data that are associated with a sampling event such as net height, start lattitude, depth, distance fished, etc.'
/
COMMENT ON COLUMN clamsbase2.EVENT_PARAMETERS.EVENT_PARAMETER IS 'The name of this data type. Examples are lattitude, distance fished, trawl scientist, etc.'
/
COMMENT ON COLUMN clamsbase2.EVENT_PARAMETERS.DESCRIPTION IS 'A description of the data type.'
/
COMMENT ON COLUMN clamsbase2.EVENT_PARAMETERS.SOURCE IS 'Defines where the data comes from. For example manual entry or SCS.'
/
COMMENT ON COLUMN clamsbase2.EVENT_PARAMETERS.SCS_PARAMETER_NAME IS 'If this is an SCS parameter, this is the SCS parameter name. This allows CLAMS to map SCS data parameters to CLAMS haul parameters which is required since SCS parameter names can change just because someone wants to be cheeky.'
/

-- Table clamsbase2.EVENT_PERFORMANCE

CREATE TABLE clamsbase2.EVENT_PERFORMANCE(
  PERFORMANCE_CODE Number(4,2) CONSTRAINT SYS_C00460194 NOT NULL,
  DESCRIPTION Varchar2(500 ) CONSTRAINT SYS_C00460195 NOT NULL
)
/

-- Add keys for table clamsbase2.EVENT_PERFORMANCE

ALTER TABLE clamsbase2.EVENT_PERFORMANCE ADD CONSTRAINT HAUL_PERF_PK PRIMARY KEY (PERFORMANCE_CODE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.EVENT_PERFORMANCE IS 'EVENT_PERFORMANCE decribes how well a sampling event went. Adapted from the RACE haul performance codes, these codes can be extended to add performance codes for other sampling types.'
/

-- Table clamsbase2.EVENT_STREAM_DATA

CREATE TABLE clamsbase2.EVENT_STREAM_DATA(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  EVENT_ID Number(6,2) CONSTRAINT SYS_C00460307 NOT NULL,
  DEVICE_ID Number(4,0) CONSTRAINT SYS_C00460308 NOT NULL,
  TIME_STAMP Timestamp(1) CONSTRAINT SYS_C00460309 NOT NULL,
  MEASUREMENT_TYPE Varchar2(50 ) CONSTRAINT SYS_C00460310 NOT NULL,
  MEASUREMENT_VALUE Varchar2(25 ) NOT NULL
)
/

-- Create indexes for table clamsbase2.EVENT_STREAM_DATA

CREATE INDEX EVENT_STR_DATA_TIME_IDX ON clamsbase2.EVENT_STREAM_DATA (TIME_STAMP)
/

-- Add keys for table clamsbase2.EVENT_STREAM_DATA

ALTER TABLE clamsbase2.EVENT_STREAM_DATA ADD CONSTRAINT EVENT_STR_DATA_PK PRIMARY KEY (ship,survey,EVENT_ID,DEVICE_ID,TIME_STAMP,MEASUREMENT_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.EVENT_STREAM_DATA IS 'EVENT_STREAM_DATA stores periodic data collected during a sampling event. This can be data from instruments mounted to the sampling device such as CTDs or Temp/Depth profilers or from vessel mounted instruments that collect data during the sampling event such as a GPS receiver.'
/
COMMENT ON COLUMN clamsbase2.EVENT_STREAM_DATA.EVENT_ID IS 'The event ID the data is associated with.'
/
COMMENT ON COLUMN clamsbase2.EVENT_STREAM_DATA.DEVICE_ID IS 'The device ID of the instrument this data was collected with.'
/
COMMENT ON COLUMN clamsbase2.EVENT_STREAM_DATA.TIME_STAMP IS 'The time stamp associated with this data point.'
/
COMMENT ON COLUMN clamsbase2.EVENT_STREAM_DATA.MEASUREMENT_TYPE IS 'The type of measurement. For example temperature, depth, latitude, etc.'
/
COMMENT ON COLUMN clamsbase2.EVENT_STREAM_DATA.MEASUREMENT_VALUE IS 'The data value.'
/

-- Table clamsbase2.EVENT_TYPES

CREATE TABLE clamsbase2.EVENT_TYPES(
  EVENT_TYPE Number(4,1) CONSTRAINT SYS_C00460189 NOT NULL,
  DESCRIPTION Varchar2(2000 ) CONSTRAINT SYS_C00460190 NOT NULL,
  PARAMETER_TYPE Char(20 )
)
/

-- Add keys for table clamsbase2.EVENT_TYPES

ALTER TABLE clamsbase2.EVENT_TYPES ADD CONSTRAINT HAUL_TYPES_PK PRIMARY KEY (EVENT_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.EVENT_TYPES IS 'Event Types describes how gear is deployed during a sampling event. Adapted from the RACE haul type codes that described various trawl deployments such as "Opportunistic off-bottom sample" or "Bottom trawl on pre-determined trackline", these codes have been extended to include other sampling types such as camera drops and camera tows.'
/
COMMENT ON COLUMN clamsbase2.EVENT_TYPES.EVENT_TYPE IS 'Event Type describes how gear is deployed during a sampling event.'
/

-- Table clamsbase2.HAUL_WEIGHT_TYPES

CREATE TABLE clamsbase2.HAUL_WEIGHT_TYPES(
  WEIGHT_TYPE Varchar2(50 ) CONSTRAINT SYS_C00460191 NOT NULL,
  WEIGHT_CODE Number(2,0) CONSTRAINT SYS_C00460192 NOT NULL,
  DESCRIPTION Varchar2(500 ) CONSTRAINT SYS_C00460193 NOT NULL
)
/

-- Add keys for table clamsbase2.HAUL_WEIGHT_TYPES

ALTER TABLE clamsbase2.HAUL_WEIGHT_TYPES ADD CONSTRAINT HAUL_WT_TYPE_PK PRIMARY KEY (WEIGHT_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.HAUL_WEIGHT_TYPES IS 'Haul weight types defines the methods used to derive the catch weight of the haul.'
/
COMMENT ON COLUMN clamsbase2.HAUL_WEIGHT_TYPES.WEIGHT_TYPE IS 'The unique name for the method used to determine the catch weight.'
/
COMMENT ON COLUMN clamsbase2.HAUL_WEIGHT_TYPES.WEIGHT_CODE IS 'The RACE code for weight type.'
/
COMMENT ON COLUMN clamsbase2.HAUL_WEIGHT_TYPES.DESCRIPTION IS 'An informative description of the weight type.'
/

-- Table clamsbase2.MATURITY_DESCRIPTION

CREATE TABLE clamsbase2.MATURITY_DESCRIPTION(
  MATURITY_TABLE Number(2,0) CONSTRAINT SYS_C00460241 NOT NULL,
  MATURITY_KEY Number(2,0) CONSTRAINT SYS_C00460242 NOT NULL,
  DESCRIPTION_TEXT_MALE Varchar2(500 ) CONSTRAINT SYS_C00460243 NOT NULL,
  DESCRIPTION_TEXT_FEMALE Varchar2(500 ) CONSTRAINT SYS_C00460244 NOT NULL,
  BUTTON_TEXT Varchar2(50 ) CONSTRAINT SYS_C00460245 NOT NULL
)
/

-- Add keys for table clamsbase2.MATURITY_DESCRIPTION

ALTER TABLE clamsbase2.MATURITY_DESCRIPTION ADD CONSTRAINT MATURITY_DESC_PK PRIMARY KEY (MATURITY_TABLE,MATURITY_KEY)
/

-- Table clamsbase2.MATURITY_TABLES

CREATE TABLE clamsbase2.MATURITY_TABLES(
  MATURITY_TABLE Number(2,0) CONSTRAINT SYS_C00460239 NOT NULL,
  DESCRIPTION Varchar2(500 ) CONSTRAINT SYS_C00460240 NOT NULL
)
/

-- Add keys for table clamsbase2.MATURITY_TABLES

ALTER TABLE clamsbase2.MATURITY_TABLES ADD CONSTRAINT MATURITY_TABLES_PK PRIMARY KEY (MATURITY_TABLE)
/

-- Table clamsbase2.MEASUREMENTS

CREATE TABLE clamsbase2.MEASUREMENTS(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  EVENT_ID Number(6,2) NOT NULL,
  SAMPLE_ID Number(6,0) NOT NULL,
  SPECIMEN_ID Number(10,0) CONSTRAINT SYS_C00460283 NOT NULL,
  MEASUREMENT_TYPE Varchar2(50 ) CONSTRAINT SYS_C00460284 NOT NULL,
  MEASUREMENT_VALUE Varchar2(25 ) CONSTRAINT SYS_C00460285 NOT NULL,
  DEVICE_ID Number(4,0) CONSTRAINT SYS_C00460286 NOT NULL
)
/

-- Add keys for table clamsbase2.MEASUREMENTS

ALTER TABLE clamsbase2.MEASUREMENTS ADD CONSTRAINT MEASUREMENT_PK PRIMARY KEY (ship,survey,EVENT_ID,SAMPLE_ID,SPECIMEN_ID,MEASUREMENT_TYPE)
/

-- Create triggers for table clamsbase2.MEASUREMENTS

CREATE OR REPLACE TRIGGER clamsbase2.MEASUREMENTS_BEF_UPD_ROW
  BEFORE UPDATE
  ON clamsbase2.MEASUREMENTS
 FOR EACH ROW
  DECLARE
  modTime DATE;
BEGIN
  SELECT SYSDATE INTO modTime FROM dual;

  UPDATE specimen
    SET Time_Stamp=modTime
    WHERE ship=:new.ship AND survey=:new.survey AND event_id=:new.event_id AND sample_id=:new.sample_id AND specimen_id=:new.specimen_id;
END MEASUREMENTS_BEF_UPD_ROW;
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.MEASUREMENTS IS 'Stores the individual measurements taken from specimens.'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENTS.SAMPLE_ID IS 'The ID of the sample the specimen identified by specimen_id comes from.'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENTS.SPECIMEN_ID IS 'The unique id of the specimen this measurement applies to.'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENTS.MEASUREMENT_TYPE IS 'The type of measurement. Examples are Length, Weight, etc.'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENTS.MEASUREMENT_VALUE IS 'The measurement value stored as text. Use the information from Measurement_Type.Data_Type to re-cast to the original data type.'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENTS.DEVICE_ID IS 'The device ID of the device used to acquire this measurment.'
/

-- Table clamsbase2.MEASUREMENT_SETUP

CREATE TABLE clamsbase2.MEASUREMENT_SETUP(
  WORKSTATION_ID Number(3,0) CONSTRAINT SYS_C00460171 NOT NULL,
  MEASUREMENT_TYPE Varchar2(50 ) CONSTRAINT SYS_C00460172 NOT NULL,
  DEVICE_ID Number(4,0) CONSTRAINT SYS_C00460173 NOT NULL,
  DEVICE_INTERFACE Varchar2(30 ) CONSTRAINT SYS_C00460174 NOT NULL,
  GUI_MODULE Varchar2(50 ) CONSTRAINT SYS_C00460175 NOT NULL
)
/

-- Add keys for table clamsbase2.MEASUREMENT_SETUP

ALTER TABLE clamsbase2.MEASUREMENT_SETUP ADD CONSTRAINT M_SETUP_PK PRIMARY KEY (WORKSTATION_ID,MEASUREMENT_TYPE,GUI_MODULE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.MEASUREMENT_SETUP IS 'Measurement Setup links a specific measurement, for example length, to a workstaion, GUI_Module, and a device at that workstation.'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENT_SETUP.WORKSTATION_ID IS 'The ID of the workstation this record applies to.'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENT_SETUP.MEASUREMENT_TYPE IS 'The measurement type - such as Length, Weight, etc.'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENT_SETUP.DEVICE_ID IS 'The device ID of the device attached at this records workstation which will provide data for the specified measurement type. For example a scale will provide data for a weight measurement.'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENT_SETUP.DEVICE_INTERFACE IS 'Specifies how the device is attached to the workstation. Examples are SERIAL for a device attached to the serial port, and SOFTWARE for a software based device.'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENT_SETUP.GUI_MODULE IS 'The CLAMS module this measurement type is associated with. For example CLAMS_Specimen or CLAMS_Length.'
/

-- Table clamsbase2.MEASUREMENT_TYPES

CREATE TABLE clamsbase2.MEASUREMENT_TYPES(
  MEASUREMENT_TYPE Varchar2(50 ) CONSTRAINT SYS_C00460167 NOT NULL,
  PARAMETER_TYPE Varchar2(32 ),
  PARAMETER_UNIT Varchar2(32 ),
  DESCRIPTION Varchar2(2000 ),
  IS_LENGTH Number(1,0) DEFAULT 0 NOT NULL
)
/

-- Add keys for table clamsbase2.MEASUREMENT_TYPES

ALTER TABLE clamsbase2.MEASUREMENT_TYPES ADD CONSTRAINT MEASUREMENT_TYPES_PK PRIMARY KEY (MEASUREMENT_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.MEASUREMENT_TYPES IS 'Stores the possible biological measurement types.'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENT_TYPES.MEASUREMENT_TYPE IS 'The unique name for this measurement type. Examples are length, organism_weight, stomach_weight, sex, etc.'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENT_TYPES.DESCRIPTION IS 'A description of the measurement type. A good description is very helpful!'
/
COMMENT ON COLUMN clamsbase2.MEASUREMENT_TYPES.IS_LENGTH IS 'This column should be set to 1 if the measurement type is a "length" measurement. This should be set to 1 for measurements such as bell_diameter, wing_span, total_length, fork_length, etc.'
/

-- Table clamsbase2.OVERRIDES

CREATE TABLE clamsbase2.OVERRIDES(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  EVENT_ID Number(6,2) NOT NULL,
  RECORD_ID Number(9,0) CONSTRAINT SYS_C00460301 NOT NULL,
  TABLE_NAME Varchar2(50 ) CONSTRAINT SYS_C00460302 NOT NULL,
  SCIENTIST Varchar2(64 ) CONSTRAINT SYS_C00460300 NOT NULL,
  DESCRIPTION Varchar2(4000 ) CONSTRAINT SYS_C00460303 NOT NULL,
  TIME_STAMP Date DEFAULT SYSDATE CONSTRAINT SYS_C00460304 NOT NULL
)
/

-- Add keys for table clamsbase2.OVERRIDES

ALTER TABLE clamsbase2.OVERRIDES ADD CONSTRAINT OVERRIDE_PK PRIMARY KEY (ship,survey,EVENT_ID,RECORD_ID,TABLE_NAME,SCIENTIST)
/

-- Create triggers for table clamsbase2.OVERRIDES

CREATE OR REPLACE TRIGGER clamsbase2.OVERRIDES_BEF_INS_UPD_ROW
  BEFORE INSERT OR UPDATE
  ON clamsbase2.OVERRIDES
 REFERENCING  OLD AS old NEW AS new
 FOR EACH ROW
  BEGIN SELECT SYSDATE INTO :new.Time_Stamp FROM dual; END OVERRIDES_BEF_INS_UPD_ROW;
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.OVERRIDES IS 'The override table stores information on overrides. An override is any case where a conditional fails but the user chooses to ignore the error.'
/
COMMENT ON COLUMN clamsbase2.OVERRIDES.RECORD_ID IS 'The ID of the record that the override applies to.'
/
COMMENT ON COLUMN clamsbase2.OVERRIDES.TABLE_NAME IS 'The table the record ID refers to.'
/
COMMENT ON COLUMN clamsbase2.OVERRIDES.SCIENTIST IS 'The name of the user who chose to override the conditional warning.'
/
COMMENT ON COLUMN clamsbase2.OVERRIDES.DESCRIPTION IS 'The conditional that was ignored.'
/
COMMENT ON COLUMN clamsbase2.OVERRIDES.TIME_STAMP IS 'The date/time of the override.'
/

-- Table clamsbase2.PERSONNEL

CREATE TABLE clamsbase2.PERSONNEL(
  SCIENTIST Varchar2(64 ) CONSTRAINT SYS_C00460186 NOT NULL,
  AFFILIATION Varchar2(64 ) CONSTRAINT SYS_C00460187 NOT NULL,
  ACTIVE Number(1,0) CONSTRAINT SYS_C00460188 NOT NULL,
  UUID Varchar2(36 ),
  EMAIL Varchar2(128 )
)
/

-- Add keys for table clamsbase2.PERSONNEL

ALTER TABLE clamsbase2.PERSONNEL ADD CONSTRAINT PERSONNEL_PK PRIMARY KEY (SCIENTIST)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.PERSONNEL IS 'Personnel contains the names and affiliations of the individuals involved in the collection, processing, analysis, and archiving of data collected using CLAMS and (for the MACE group) processed acoustic data.'
/
COMMENT ON COLUMN clamsbase2.PERSONNEL.SCIENTIST IS 'Full name of the scientist or technician.'
/
COMMENT ON COLUMN clamsbase2.PERSONNEL.AFFILIATION IS 'The scientists affiliation. AFSC, TINRO, UW, etc.'
/
COMMENT ON COLUMN clamsbase2.PERSONNEL.ACTIVE IS 'A 1 marks the scientist as active and the name will be listed in the CLAMS application GUI. 0 will mark an entry as inactive and it will not appear in the GUI.'
/
COMMENT ON COLUMN clamsbase2.PERSONNEL.UUID IS 'UUID contains a string representation of the UUID assigned to this scientist. Typically UUID''s are used as a unique key for scientists in metadata databases.'
/
COMMENT ON COLUMN clamsbase2.PERSONNEL.EMAIL IS 'The primary work email address for this individual. This entry is only required for chief scientists and data stewards.'
/

-- Table clamsbase2.PROTOCOL_DEFINITIONS

CREATE TABLE clamsbase2.PROTOCOL_DEFINITIONS(
  PROTOCOL_NAME Varchar2(50 ) CONSTRAINT SYS_C00460178 NOT NULL,
  MEASUREMENT_ORDER Number(2,0) CONSTRAINT SYS_C00460179 NOT NULL,
  FORCE_MEASUREMENT Number(1,0) CONSTRAINT SYS_C00460180 NOT NULL,
  FORCE_ORDER Number(1,0) CONSTRAINT SYS_C00460181 NOT NULL,
  LABEL Varchar2(30 )
)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.PROTOCOL_DEFINITIONS IS 'Protocol Definition links a protocol with measurements that define the protocol.'
/
COMMENT ON COLUMN clamsbase2.PROTOCOL_DEFINITIONS.PROTOCOL_NAME IS 'The protocol name that this measurement is associated with.'
/
COMMENT ON COLUMN clamsbase2.PROTOCOL_DEFINITIONS.MEASUREMENT_ORDER IS 'The order this measurement ocurrs in the protocol.'
/
COMMENT ON COLUMN clamsbase2.PROTOCOL_DEFINITIONS.FORCE_MEASUREMENT IS 'If set, this measurement is required.'
/
COMMENT ON COLUMN clamsbase2.PROTOCOL_DEFINITIONS.FORCE_ORDER IS 'If set, this measurement must be done in the specified order.'
/
COMMENT ON COLUMN clamsbase2.PROTOCOL_DEFINITIONS.LABEL IS 'The text that is placed on the protocol button in the GUI.'
/

-- Table clamsbase2.PROTOCOL_MAP

CREATE TABLE clamsbase2.PROTOCOL_MAP(
  PROTOCOL_NAME Varchar2(50 ) NOT NULL,
  SPECIES_CODE Number(7,0) NOT NULL,
  SUBCATEGORY Varchar2(128 ) NOT NULL,
  ACTIVE Number(1,0) CONSTRAINT SYS_C00460262 NOT NULL
)
/

-- Add keys for table clamsbase2.PROTOCOL_MAP

ALTER TABLE clamsbase2.PROTOCOL_MAP ADD CONSTRAINT PROTO_MAP_PK PRIMARY KEY (PROTOCOL_NAME,SPECIES_CODE,SUBCATEGORY)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.PROTOCOL_MAP IS 'Protocol Map maps protocols to species. A species can have any number of protocols assigned to it. If you are collecting maturity as part of a protocol, you MUST specify the maturity table to use here. Active protocols are marked with a 1 in the Active column and will show up in CLAMS. Inactive protocols are marked with a 0 and will not show up in the CLAMS GUI.'
/
COMMENT ON COLUMN clamsbase2.PROTOCOL_MAP.PROTOCOL_NAME IS 'The protocol that you are mapping to this species.'
/
COMMENT ON COLUMN clamsbase2.PROTOCOL_MAP.SPECIES_CODE IS 'The species code that identifies the species this protocol will be available for during sampling.'
/
COMMENT ON COLUMN clamsbase2.PROTOCOL_MAP.SUBCATEGORY IS 'The species subcategory this protocol will be limited to.'
/
COMMENT ON COLUMN clamsbase2.PROTOCOL_MAP.ACTIVE IS 'Set to 1 to mark this protocol as active and to display it in the GUI. Set to 0 to mark as inactive.'
/

-- Table clamsbase2.SAMPLES

CREATE TABLE clamsbase2.SAMPLES(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  EVENT_ID Number(6,2) CONSTRAINT SYS_C00460266 NOT NULL,
  SAMPLE_ID Number(6,0) CONSTRAINT SYS_C00460263 NOT NULL,
  PARENT_SAMPLE Number(6,0),
  PARTITION Varchar2(50 ) CONSTRAINT SYS_C00460267 NOT NULL,
  SAMPLE_TYPE Varchar2(25 ) CONSTRAINT SYS_C00460268 NOT NULL,
  SPECIES_CODE Number(7,0),
  SUBCATEGORY Varchar2(128 ),
  SCIENTIST Varchar2(64 ) CONSTRAINT SYS_C00460270 NOT NULL,
  TIME_STAMP Date DEFAULT SYSDATE CONSTRAINT SYS_C00460269 NOT NULL,
  COMMENTS Varchar2(4000 )
)
/

-- Add keys for table clamsbase2.SAMPLES

ALTER TABLE clamsbase2.SAMPLES ADD CONSTRAINT SAMPLE_PK PRIMARY KEY (ship,survey,EVENT_ID,SAMPLE_ID)
/

-- Create triggers for table clamsbase2.SAMPLES

CREATE OR REPLACE TRIGGER clamsbase2.SAMPLE_BEF_UPD_ROW
  BEFORE UPDATE
  ON clamsbase2.SAMPLES
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN SELECT SYSDATE INTO :new.Time_Stamp FROM dual; END SAMPLE_BEF_UPD_ROW;
/

CREATE OR REPLACE TRIGGER clamsbase2.SAMPLE_BEF_INS_ROW
  BEFORE INSERT
  ON clamsbase2.SAMPLES
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN SELECT SAMPLE_ID_SEQ.NextVal INTO :new.Sample_Id FROM dual; END SAMPLE_BEF_INS_ROW;
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.SAMPLES IS 'Sample describes a collection of organisms you have taken from your sampling event (Trawl, camera tow, Methot, etc).'
/
COMMENT ON COLUMN clamsbase2.SAMPLES.EVENT_ID IS 'The event ID this sample is associated with.'
/
COMMENT ON COLUMN clamsbase2.SAMPLES.SAMPLE_ID IS 'A unique ID identifying this sample. Sample IDs are unique across surveys and ships.'
/
COMMENT ON COLUMN clamsbase2.SAMPLES.PARENT_SAMPLE IS 'If this is a sub-sample, this field will contain the sample_id of the parent sample. If this field is null, it is a parent sample that may or may not have any child samples.'
/
COMMENT ON COLUMN clamsbase2.SAMPLES.PARTITION IS 'The gear partition this sample was taken from.'
/
COMMENT ON COLUMN clamsbase2.SAMPLES.SCIENTIST IS 'The scientist who collected this sample.'
/
COMMENT ON COLUMN clamsbase2.SAMPLES.TIME_STAMP IS 'The time this sample was collected.'
/
COMMENT ON COLUMN clamsbase2.SAMPLES.COMMENTS IS 'Contains any comments associated with this sample.'
/

-- Table clamsbase2.SAMPLE_DATA

CREATE TABLE clamsbase2.SAMPLE_DATA(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  EVENT_ID Number(6,2) NOT NULL,
  SAMPLE_ID Number(6,0) NOT NULL,
  SAMPLE_PARAMETER Varchar2(50 ) CONSTRAINT SYS_C00460275 NOT NULL,
  PARAMETER_VALUE Varchar2(250 ) NOT NULL
)
/

-- Add keys for table clamsbase2.SAMPLE_DATA

ALTER TABLE clamsbase2.SAMPLE_DATA ADD CONSTRAINT SAMPLE_DATA_PK PRIMARY KEY (SAMPLE_PARAMETER,SAMPLE_ID,EVENT_ID,survey,ship)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.SAMPLE_DATA IS 'Sample Data stores data such as sample name, flow scale readings, basket weights, etc. associated with a sample.'
/
COMMENT ON COLUMN clamsbase2.SAMPLE_DATA.SAMPLE_PARAMETER IS 'Sample parameter identifies the data (the parameter_value) that is associated with this record. Additional information such as the data type (integer, string, float) and the parameter type description can be found in the sample_parameters table.'
/
COMMENT ON COLUMN clamsbase2.SAMPLE_DATA.PARAMETER_VALUE IS 'The data associated with this sample ID and haul parameter.'
/

-- Table clamsbase2.SAMPLE_PARAMETERS

CREATE TABLE clamsbase2.SAMPLE_PARAMETERS(
  SAMPLE_PARAMETER Varchar2(50 ) CONSTRAINT SYS_C00460271 NOT NULL,
  PARAMETER_TYPE Varchar2(32 ),
  PARAMETER_UNIT Varchar2(32 ),
  DESCRIPTION Varchar2(250 ) CONSTRAINT SYS_C00460273 NOT NULL
)
/

-- Add keys for table clamsbase2.SAMPLE_PARAMETERS

ALTER TABLE clamsbase2.SAMPLE_PARAMETERS ADD CONSTRAINT SAMPLE_PARMS_PK PRIMARY KEY (SAMPLE_PARAMETER)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.SAMPLE_PARAMETERS IS 'Haul Parameters contains descriptions of the types of data that are associated with a sample such as sample name, flow scale readings, etc.'
/
COMMENT ON COLUMN clamsbase2.SAMPLE_PARAMETERS.SAMPLE_PARAMETER IS 'The name of this data type. Examples are start flow scale reading, end flow scale reading, sample name, etc.'
/
COMMENT ON COLUMN clamsbase2.SAMPLE_PARAMETERS.DESCRIPTION IS 'A description of the data type.'
/

-- Table clamsbase2.SAMPLE_TYPES

CREATE TABLE clamsbase2.SAMPLE_TYPES(
  SAMPLE_TYPE Varchar2(25 ) CONSTRAINT SYS_C00460233 NOT NULL,
  DESCRIPTION Varchar2(500 ) CONSTRAINT SYS_C00460234 NOT NULL
)
/

-- Add keys for table clamsbase2.SAMPLE_TYPES

ALTER TABLE clamsbase2.SAMPLE_TYPES ADD CONSTRAINT SAMPLE_TYPES_PK PRIMARY KEY (SAMPLE_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.SAMPLE_TYPES IS 'Sample Types defines the valid sampling methods and maps them to gear type.'
/
COMMENT ON COLUMN clamsbase2.SAMPLE_TYPES.SAMPLE_TYPE IS 'The name of the sample type. Examples are Count, Subsample, Toss, etc.'
/
COMMENT ON COLUMN clamsbase2.SAMPLE_TYPES.DESCRIPTION IS 'A description of the sample type.'
/

-- Table clamsbase2.SAMPLING_METHODS

CREATE TABLE clamsbase2.SAMPLING_METHODS(
  SAMPLING_METHOD Varchar2(25 ) CONSTRAINT SYS_C00460235 NOT NULL,
  DESCRIPTION Varchar2(2000 ) CONSTRAINT SYS_C00460236 NOT NULL
)
/

-- Add keys for table clamsbase2.SAMPLING_METHODS

ALTER TABLE clamsbase2.SAMPLING_METHODS ADD CONSTRAINT SAMPLE_METHODS_PK PRIMARY KEY (SAMPLING_METHOD)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.SAMPLING_METHODS IS 'Sampling methods defines the sampling methods and maps them to gear type.'
/
COMMENT ON COLUMN clamsbase2.SAMPLING_METHODS.SAMPLING_METHOD IS 'The name of the sampling method. Examples are Random, etc.'
/
COMMENT ON COLUMN clamsbase2.SAMPLING_METHODS.DESCRIPTION IS 'A description of the sampling method.'
/

-- Table clamsbase2.SPECIES

CREATE TABLE clamsbase2.SPECIES(
  SPECIES_CODE Number(7,0) CONSTRAINT SYS_C00460246 NOT NULL,
  PARENT_TAXON Number(7,0),
  SCIENTIFIC_NAME Varchar2(128 ) NOT NULL,
  COMMON_NAME Varchar2(128 ) NOT NULL
)
/

-- Add keys for table clamsbase2.SPECIES

ALTER TABLE clamsbase2.SPECIES ADD CONSTRAINT SPECIES_PK PRIMARY KEY (SPECIES_CODE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.SPECIES IS 'Species is a lookup table that contains species codes, names, and other species specific data.'
/

-- Table clamsbase2.SPECIMEN

CREATE TABLE clamsbase2.SPECIMEN(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  EVENT_ID Number(6,2) NOT NULL,
  SAMPLE_ID Number(6,0) CONSTRAINT SYS_C00460279 NOT NULL,
  SPECIMEN_ID Number(10,0) CONSTRAINT SYS_C00460276 NOT NULL,
  WORKSTATION_ID Number(3,0) CONSTRAINT SYS_C00460277 NOT NULL,
  SCIENTIST Varchar2(64 ) CONSTRAINT SYS_C00460278 NOT NULL,
  SAMPLING_METHOD Varchar2(25 ) CONSTRAINT SYS_C00460280 NOT NULL,
  PROTOCOL_NAME Varchar2(50 ) CONSTRAINT SYS_C00460281 NOT NULL,
  MATURITY_TABLE Number(2,0),
  TIME_STAMP Date DEFAULT SYSDATE CONSTRAINT SYS_C00460282 NOT NULL,
  COMMENTS Varchar2(4000 )
)
/

-- Add keys for table clamsbase2.SPECIMEN

ALTER TABLE clamsbase2.SPECIMEN ADD CONSTRAINT SPECIMEN_PK PRIMARY KEY (ship,survey,EVENT_ID,SAMPLE_ID,SPECIMEN_ID)
/

-- Create triggers for table clamsbase2.SPECIMEN

CREATE OR REPLACE TRIGGER clamsbase2.SPECIMEN_BEF_UPD_ROW
  BEFORE UPDATE
  ON clamsbase2.SPECIMEN
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN SELECT SYSDATE INTO :new.Time_Stamp FROM dual; END SPECIMEN_BEF_UPD_ROW;
/

CREATE OR REPLACE TRIGGER clamsbase2.SPECIMEN_BEF_INS_ROW
  BEFORE INSERT
  ON clamsbase2.SPECIMEN
 REFERENCING  OLD AS OLD NEW AS NEW
 FOR EACH ROW
  BEGIN SELECT SPECIMEN_ID_SEQ.NextVal INTO :new.Specimen_Id FROM dual; END SPECIMEN_BEF_INS_ROW;
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.SPECIMEN IS 'Specimen contains information regarding individual organisms that have had measurements taken or observations made about them. The actual measurements or observations are stored in the measurements table and are keyed by the unique specimen ID.'
/
COMMENT ON COLUMN clamsbase2.SPECIMEN.EVENT_ID IS 'The event this specimen was collected from.'
/
COMMENT ON COLUMN clamsbase2.SPECIMEN.SAMPLE_ID IS 'The sample ID of the sample this specimen is taken from.'
/
COMMENT ON COLUMN clamsbase2.SPECIMEN.SPECIMEN_ID IS 'A unique ID for this sample. It is unique between '
/
COMMENT ON COLUMN clamsbase2.SPECIMEN.WORKSTATION_ID IS 'The ID of the workstation this sample was collected at.'
/
COMMENT ON COLUMN clamsbase2.SPECIMEN.SCIENTIST IS 'The Scientist that collected this specimen.'
/
COMMENT ON COLUMN clamsbase2.SPECIMEN.PROTOCOL_NAME IS 'The protocol used to collect this specimen.'
/
COMMENT ON COLUMN clamsbase2.SPECIMEN.MATURITY_TABLE IS 'The maturity table used if maturity was collected for this specimen.'
/
COMMENT ON COLUMN clamsbase2.SPECIMEN.TIME_STAMP IS 'The time and date this sample was taken'
/
COMMENT ON COLUMN clamsbase2.SPECIMEN.COMMENTS IS 'Comments on this sample.'
/

-- Table clamsbase2.SPECIMEN_PROTOCOL

CREATE TABLE clamsbase2.SPECIMEN_PROTOCOL(
  PROTOCOL_NAME Varchar2(50 ) CONSTRAINT SYS_C00460176 NOT NULL,
  DESCRIPTION Varchar2(2048 ) CONSTRAINT SYS_C00460177 NOT NULL
)
/

-- Add keys for table clamsbase2.SPECIMEN_PROTOCOL

ALTER TABLE clamsbase2.SPECIMEN_PROTOCOL ADD CONSTRAINT SPEC_PROTOCOL_PK PRIMARY KEY (PROTOCOL_NAME)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.SPECIMEN_PROTOCOL IS 'Specimen Protocol contains the names and descriptions of the protocols that have been used to collect biological data.'
/
COMMENT ON COLUMN clamsbase2.SPECIMEN_PROTOCOL.PROTOCOL_NAME IS 'The unique name for the protocol. For special studies protocols the name should include the year.'
/
COMMENT ON COLUMN clamsbase2.SPECIMEN_PROTOCOL.DESCRIPTION IS 'An informative summary of the protocol.'
/

-- Table clamsbase2.VALIDATIONS

CREATE TABLE clamsbase2.VALIDATIONS(
  VALIDATION Varchar2(50 ) CONSTRAINT SYS_C00460314 NOT NULL,
  PROTOCOL_NAME Varchar2(50 ) CONSTRAINT SYS_C00460315 NOT NULL,
  MEASUREMENT_TYPE Varchar2(50 ) CONSTRAINT SYS_C00460316 NOT NULL,
  VALIDATION_ORDER Number(2,0) DEFAULT 1 CONSTRAINT SYS_C00460317 NOT NULL
)
/

-- Add keys for table clamsbase2.VALIDATIONS

ALTER TABLE clamsbase2.VALIDATIONS ADD CONSTRAINT VALIDATIONS_PK PRIMARY KEY (VALIDATION,PROTOCOL_NAME,MEASUREMENT_TYPE,VALIDATION_ORDER)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.VALIDATIONS IS 'Validations maps validations to a measurement type and protocol. Validations are python classes that check measurement values to ensure they are within spec. Examples are checking if a length measurement is within a minimum and maximum bound or if a barcode value is a duplicate.'
/
COMMENT ON COLUMN clamsbase2.VALIDATIONS.VALIDATION IS 'Foreign Key - see comments on parent VALIDATION_DEFINITIONS.Validation.'
/
COMMENT ON COLUMN clamsbase2.VALIDATIONS.PROTOCOL_NAME IS 'Foreign Key - see comments on parent SPECIMEN_PROTOCOL.Protocol_Name.'
/
COMMENT ON COLUMN clamsbase2.VALIDATIONS.MEASUREMENT_TYPE IS 'Foreign Key - see comments on parent MEASUREMENT_TYPES.Measurement_Type.'
/
COMMENT ON COLUMN clamsbase2.VALIDATIONS.VALIDATION_ORDER IS 'Validation order defines the order that validations are called when more than one validation exists for a protocol and measurement type.'
/

-- Table clamsbase2.VALIDATION_CONFIGURATION

CREATE TABLE clamsbase2.VALIDATION_CONFIGURATION(
  VALIDATION Varchar2(50 ) NOT NULL,
  PARAMETER Varchar2(50 ) CONSTRAINT SYS_C00460295 NOT NULL,
  PARAMETER_VALUE Varchar2(500 ) CONSTRAINT SYS_C00460296 NOT NULL,
  DESCRIPTION Varchar2(500 )
)
/

-- Add keys for table clamsbase2.VALIDATION_CONFIGURATION

ALTER TABLE clamsbase2.VALIDATION_CONFIGURATION ADD CONSTRAINT VAL_CONFIG_PK PRIMARY KEY (PARAMETER,VALIDATION)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.VALIDATION_CONFIGURATION IS 'Stores parameters used by the validation modules.'
/
COMMENT ON COLUMN clamsbase2.VALIDATION_CONFIGURATION.PARAMETER IS 'The parameter name. For example: MaxBasketWt'
/
COMMENT ON COLUMN clamsbase2.VALIDATION_CONFIGURATION.PARAMETER_VALUE IS 'The parameter value. For example: 40'
/

-- Table clamsbase2.VALIDATION_DEFINITIONS

CREATE TABLE clamsbase2.VALIDATION_DEFINITIONS(
  VALIDATION Varchar2(50 ) CONSTRAINT SYS_C00460311 NOT NULL,
  MODULE Varchar2(50 ) CONSTRAINT SYS_C00460312 NOT NULL,
  DESCRIPTION Varchar2(2000 ) CONSTRAINT SYS_C00460313 NOT NULL
)
/

-- Add keys for table clamsbase2.VALIDATION_DEFINITIONS

ALTER TABLE clamsbase2.VALIDATION_DEFINITIONS ADD CONSTRAINT VALIDATION_DEF_PK PRIMARY KEY (VALIDATION)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.VALIDATION_DEFINITIONS IS 'Validation Definitions maps validations to the python module that is called to perform the validation.'
/
COMMENT ON COLUMN clamsbase2.VALIDATION_DEFINITIONS.VALIDATION IS 'The name of the validation. Must be unique.'
/
COMMENT ON COLUMN clamsbase2.VALIDATION_DEFINITIONS.MODULE IS 'Module contains the name of the Python module that is called to perform this validation.'
/
COMMENT ON COLUMN clamsbase2.VALIDATION_DEFINITIONS.DESCRIPTION IS 'A description of the validation.'
/

-- Table clamsbase2.WORKSTATIONS

CREATE TABLE clamsbase2.WORKSTATIONS(
  WORKSTATION_ID Number(3,0) CONSTRAINT SYS_C00460156 NOT NULL,
  HOSTNAME Varchar2(255 ) CONSTRAINT SYS_C00460157 NOT NULL,
  STATUS Varchar2(10 ) DEFAULT 'Closed' CONSTRAINT SYS_C00460158 NOT NULL,
  DESCRIPTION Varchar2(4000 ) CONSTRAINT SYS_C00460159 NOT NULL,
  ACTIVE Number(1,0)
)
/

-- Add keys for table clamsbase2.WORKSTATIONS

ALTER TABLE clamsbase2.WORKSTATIONS ADD CONSTRAINT WORKSTATION_PK PRIMARY KEY (WORKSTATION_ID)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.WORKSTATIONS IS 'Work Station maps PC host names to a workstation ID which is used throughout CLAMS.'
/
COMMENT ON COLUMN clamsbase2.WORKSTATIONS.WORKSTATION_ID IS 'The unique workstation ID.'
/
COMMENT ON COLUMN clamsbase2.WORKSTATIONS.HOSTNAME IS 'The host name of the workstation (result of the hostname command on linux or the windows equiv.'
/
COMMENT ON COLUMN clamsbase2.WORKSTATIONS.STATUS IS 'The status of the workstation - Open or Closed'
/
COMMENT ON COLUMN clamsbase2.WORKSTATIONS.DESCRIPTION IS 'A description of the workstation. For example its location or specific function.'
/

-- Table clamsbase2.WORKSTATION_CONFIGURATION

CREATE TABLE clamsbase2.WORKSTATION_CONFIGURATION(
  WORKSTATION_ID Number(3,0) CONSTRAINT SYS_C00460297 NOT NULL,
  PARAMETER Varchar2(50 ) CONSTRAINT SYS_C00460298 NOT NULL,
  PARAMETER_VALUE Varchar2(500 ) CONSTRAINT SYS_C00460299 NOT NULL,
  DESCRIPTION Varchar2(500 )
)
/

-- Add keys for table clamsbase2.WORKSTATION_CONFIGURATION

ALTER TABLE clamsbase2.WORKSTATION_CONFIGURATION ADD CONSTRAINT WRK_CONFIG_PK PRIMARY KEY (WORKSTATION_ID,PARAMETER)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.WORKSTATION_CONFIGURATION IS 'Stores parameters specific to individual workstations used by the CLAMS application.'
/
COMMENT ON COLUMN clamsbase2.WORKSTATION_CONFIGURATION.WORKSTATION_ID IS 'The ID of the workstation this parameter applies to.'
/
COMMENT ON COLUMN clamsbase2.WORKSTATION_CONFIGURATION.PARAMETER IS 'The parameter name. For example: ImageDir'
/
COMMENT ON COLUMN clamsbase2.WORKSTATION_CONFIGURATION.PARAMETER_VALUE IS 'The parameter value. For example: C:\CLAMS\Images'
/

-- Table clamsbase2.SPECIES_PARAMETERS

CREATE TABLE clamsbase2.SPECIES_PARAMETERS(
  SPECIES_PARAMETER Varchar2(128 ) NOT NULL,
  DESCRIPTION Varchar2(2000 ) NOT NULL,
  PARAMETER_TYPE Varchar2(32 ),
  PARAMETER_UNIT Varchar2(32 )
)
/

-- Add keys for table clamsbase2.SPECIES_PARAMETERS

ALTER TABLE clamsbase2.SPECIES_PARAMETERS ADD CONSTRAINT species_parameters_pk PRIMARY KEY (SPECIES_PARAMETER)
/

-- Table clamsbase2.PARAMETER_TYPES

CREATE TABLE clamsbase2.PARAMETER_TYPES(
  PARAMETER_TYPE Varchar2(32 ) NOT NULL,
  DESCRIPTION Varchar2(2000 ) NOT NULL
)
/

-- Add keys for table clamsbase2.PARAMETER_TYPES

ALTER TABLE clamsbase2.PARAMETER_TYPES ADD CONSTRAINT parameter_types_pk PRIMARY KEY (PARAMETER_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.PARAMETER_TYPES IS 'PARAMETER_TYPE describes the data types of the values associated with the various "parameters" tables. These "parameters" tables are used to store properties of entries in their parent table as parameter/value pairs without requiring explicit columns in the parent table. For example, the SPECIES_PARAMETERS table store information such as the minimum and maximum length allowed for entries in the SPECIES table. In order to maintain flexibility, all values are stored as strings but we specify the "native" type of the parameter when the parameter is defined so we can convert or cast the value back to its native type.

The PARAMETER_TYPE field can contain one of the following types:

float - parameter should be interpreted/cast to a float
integer - parameter should be interpreted/cast to an integer
boolean - parameter should be interpreted/cast to a boolean
date - parameter should be interpreted/cast to an date
timestamp -  parameter should be interpreted/cast to an timestamp
string - parameter should not be recast
code table - parameters of this type are interpreted as labels for
                   supplementary species codes. For example, if the
                   species_parameter was "XYZ" and the type was
                   "code page" all values attached to the parameter
                   "XYZ" would be interpreted as species codes.
'
/
COMMENT ON COLUMN clamsbase2.PARAMETER_TYPES.PARAMETER_TYPE IS 'Specifies if the data is INTEGER, FLOAT, BOOLEAN, STRING, DATE, or CODE_TYPE. Can be used to convert (recast) the internal string representation to the original data type.'
/

-- Table clamsbase2.SPECIES_SUBCATEGORIES

CREATE TABLE clamsbase2.SPECIES_SUBCATEGORIES(
  SUBCATEGORY Varchar2(128 ) NOT NULL,
  DESCRIPTION Varchar2(2000 )
)
/

-- Add keys for table clamsbase2.SPECIES_SUBCATEGORIES

ALTER TABLE clamsbase2.SPECIES_SUBCATEGORIES ADD CONSTRAINT species_subcategory_PK PRIMARY KEY (SUBCATEGORY)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.SPECIES_SUBCATEGORIES IS 'Defines arbitrary collections of organisms BELOW the species level which are used primarily for reporting purposes. For example, in MACE we divide Pollock into different age classes/length modes. Historically this was done using fake species codes between 21471-21474 which was clumsy, Now we create subcategories for these modes such as Small, Medium, Large, etc. which can be linked to the sample to further describe the sample beyond the species code. Another example would be sex categories for goups that sort and sample their organisms by sex.'
/

-- Table clamsbase2.SPECIES_ASSOCIATIONS

CREATE TABLE clamsbase2.SPECIES_ASSOCIATIONS(
  SPECIES_CODE Number(7,0) NOT NULL,
  SUBCATEGORY Varchar2(128 ) NOT NULL
)
/

-- Add keys for table clamsbase2.SPECIES_ASSOCIATIONS

ALTER TABLE clamsbase2.SPECIES_ASSOCIATIONS ADD CONSTRAINT SP_ASSOC_PK PRIMARY KEY (SUBCATEGORY,SPECIES_CODE)
/

-- Table clamsbase2.PARAMETER_UNITS

CREATE TABLE clamsbase2.PARAMETER_UNITS(
  PARAMETER_UNITS Varchar2(32 ) NOT NULL,
  DESCRIPTION Varchar2(2000 ) NOT NULL
)
/

-- Add keys for table clamsbase2.PARAMETER_UNITS

ALTER TABLE clamsbase2.PARAMETER_UNITS ADD CONSTRAINT param_units_pk PRIMARY KEY (PARAMETER_UNITS)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.PARAMETER_UNITS IS 'PARAMETER_UNITS describes the units attached to various parameter_types stored in the parameter/parameter_value data tables.'
/

-- Table clamsbase2.SPECIES_DATA

CREATE TABLE clamsbase2.SPECIES_DATA(
  SPECIES_CODE Number(7,0) NOT NULL,
  SUBCATEGORY Varchar2(128 ) NOT NULL,
  SPECIES_PARAMETER Varchar2(128 ) NOT NULL,
  PARAMETER_VALUE Varchar2(128 ) NOT NULL
)
/

-- Add keys for table clamsbase2.SPECIES_DATA

ALTER TABLE clamsbase2.SPECIES_DATA ADD CONSTRAINT SP_DATA_PK PRIMARY KEY (SPECIES_CODE,SPECIES_PARAMETER,SUBCATEGORY)
/

-- Table clamsbase2.survey_regions

CREATE TABLE clamsbase2.survey_regions(
  region Varchar2(128 ) NOT NULL,
  description Varchar2(4000 )
)
/

-- Add keys for table clamsbase2.survey_regions

ALTER TABLE clamsbase2.survey_regions ADD CONSTRAINT survey_regions_pk PRIMARY KEY (region)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.survey_regions IS 'survey_regions contains the informal region names of the areas the surveys are performed in. These are region  names used to describe a survey such as "Shelikof Strait" or "Bogoslof" or "Shumigan Islands". This table serves to constrain the vocabulary used to describe a survey name which can be used when generating discovery level metadata.'
/
COMMENT ON COLUMN clamsbase2.survey_regions.region IS 'The informal region the survey was performed in. This name can be used to automatically generate a survey name to use for metadata generation.'
/
COMMENT ON COLUMN clamsbase2.survey_regions.description IS 'A description of the survey region.'
/

-- Table clamsbase2.APPLICATION_EVENTS

CREATE TABLE clamsbase2.APPLICATION_EVENTS(
  event_name Varchar2(64 ) NOT NULL,
  event_package Varchar2(128 ) NOT NULL,
  event_module Varchar2(128 ) NOT NULL,
  event_class Varchar2(128 ) NOT NULL,
  description Varchar2(4000 ),
  active Number(1,0) DEFAULT 1
)
/

-- Add keys for table clamsbase2.APPLICATION_EVENTS

ALTER TABLE clamsbase2.APPLICATION_EVENTS ADD CONSTRAINT APPLICATION_EVENTS_PK PRIMARY KEY (event_name,event_package,event_module,event_class)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.APPLICATION_EVENTS IS 'Application_Events links event names with the Python module (file) and class within that module that should be executed to collect data for said event. The event launcher will query this table and create buttons for each event listed that execute the module and class specified.'
/
COMMENT ON COLUMN clamsbase2.APPLICATION_EVENTS.event_name IS 'The name of the event. This will be shown on the button.'
/
COMMENT ON COLUMN clamsbase2.APPLICATION_EVENTS.event_module IS 'The file name/module name of the file containing the class that will be executed for this event.'
/
COMMENT ON COLUMN clamsbase2.APPLICATION_EVENTS.event_class IS 'The name of the class within the module specified for this event that will be created when the button is pressed.'
/
COMMENT ON COLUMN clamsbase2.APPLICATION_EVENTS.active IS 'Set to 1 to make this event active (visible) in CLAMS.'
/

-- Table clamsbase2.survey_sea_areas

CREATE TABLE clamsbase2.survey_sea_areas(
  IHO_sea_area Varchar2(128 ) NOT NULL,
  description Varchar2(4000 ) NOT NULL
)
/

-- Add keys for table clamsbase2.survey_sea_areas

ALTER TABLE clamsbase2.survey_sea_areas ADD CONSTRAINT SURVEY_SEA_AREAS_PK PRIMARY KEY (IHO_sea_area)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.survey_sea_areas IS 'This table contains the names of IHO sea areas that surveys will be performed in.
VLIZ (2005). IHO Sea Areas. Available online at http://www.marineregions.org/. Consulted on 2016-03-24.'
/

-- Table clamsbase2.survey_ports

CREATE TABLE clamsbase2.survey_ports(
  port Varchar2(256 ) NOT NULL,
  active Number(1,0) DEFAULT 1 NOT NULL
)
/

-- Add keys for table clamsbase2.survey_ports

ALTER TABLE clamsbase2.survey_ports ADD CONSTRAINT survey_ports_pk PRIMARY KEY (port)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.survey_ports IS 'survey_ports contains the port names where surveys begin and end.'
/

-- Table clamsbase2.QC_TYPES

CREATE TABLE clamsbase2.QC_TYPES(
  QC_TYPE Varchar2(50 ) NOT NULL,
  DESCRIPTION Varchar2(4000 ) NOT NULL
)
/

-- Add keys for table clamsbase2.QC_TYPES

ALTER TABLE clamsbase2.QC_TYPES ADD CONSTRAINT QC_TYPES_PK PRIMARY KEY (QC_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.QC_TYPES IS 'QC_TYPES is a look-up table containing the types of quality control operations that can be performed on events.'
/

-- Table clamsbase2.QUALITY_CONTROL

CREATE TABLE clamsbase2.QUALITY_CONTROL(
  survey Number(8,0) NOT NULL,
  ship Number(4,0) NOT NULL,
  EVENT_ID Number(6,2) NOT NULL,
  QC_TYPE Varchar2(50 ) NOT NULL,
  APPROVAL_STATE Number(1,0) NOT NULL,
  ERROR_COMMENTS Varchar2(4000 ),
  FIXED_COMMENTS Varchar2(4000 )
)
/

-- Add keys for table clamsbase2.QUALITY_CONTROL

ALTER TABLE clamsbase2.QUALITY_CONTROL ADD CONSTRAINT Key24 PRIMARY KEY (EVENT_ID,survey,ship,QC_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.QUALITY_CONTROL IS 'QUALITY_CONTROL contains information regarding post event processing checks. Applications present summary data to the QC analyst who determines if the results look reasonable and the analyst either approves the data or flags it for further scrutiny. Comments regarding the errors found and steps taken to fix them are recorded as well.'
/

-- Table clamsbase2.EXTENDED_SAMPLE_COLLECTIONS

CREATE TABLE clamsbase2.EXTENDED_SAMPLE_COLLECTIONS(
  EX_SAMPLE_CODE Varchar2(30 ) NOT NULL,
  BUTTON_TEXT Varchar2(30 ) NOT NULL,
  ACTIVE Number(1,0) NOT NULL,
  DESCRIPTION Varchar2(4000 ) NOT NULL
)
/

-- Add keys for table clamsbase2.EXTENDED_SAMPLE_COLLECTIONS

ALTER TABLE clamsbase2.EXTENDED_SAMPLE_COLLECTIONS ADD CONSTRAINT EX_SAMPLE_COL_PK PRIMARY KEY (EX_SAMPLE_CODE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.EXTENDED_SAMPLE_COLLECTIONS IS 'EXTENDED_SAMPLE_COLLECTIONS contains configuration data used to define the operation of the "special studies" dialog box. Due to screen space limitations, CLAMS can only present 7 or 8 measurement buttons in the specimen module. Some protocols may have a large number of sample requests linked to them, too many to fit in the normal measurement button location. To overcome this limitation a "special studies" measurement was created that is comprised of a comma delimited series of codes defining additional samples that were collected from a specimen.

Historically there were 3 measurements  that used this mechanism and the codes they used were hard coded into the measurement dialogs. Because the sample requests change from survey to survey, it was a very inflexible system that lacked documentation and required users to modify CLAMS source code to change the button and code definitions.

In 2017 this table was added and the 3 measurements/dialogs were replaced by a single measurement and dialog that is populated by data from this table. This allows the CLAMS user to alter this extended sample collections dialog by editing this table. It also provides a mechanism to document what the codes mean.'
/
COMMENT ON COLUMN clamsbase2.EXTENDED_SAMPLE_COLLECTIONS.EX_SAMPLE_CODE IS 'Text of code used to specify this sample was collected for a specimen'
/
COMMENT ON COLUMN clamsbase2.EXTENDED_SAMPLE_COLLECTIONS.BUTTON_TEXT IS 'Text to put on the dialog button for this code.'
/
COMMENT ON COLUMN clamsbase2.EXTENDED_SAMPLE_COLLECTIONS.ACTIVE IS 'Set this to 0 if this button should NOT be rendered in the dialog, 1 to render the button in the dialog.'
/

-- Table clamsbase2.protected_spp_events

CREATE TABLE clamsbase2.protected_spp_events(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  event_id Number(6,2) NOT NULL,
  time_stamp Date NOT NULL,
  latitude Number(10,7) NOT NULL,
  longitude Number(10,7) NOT NULL,
  SCIENTIST Varchar2(64 ) NOT NULL
)
/

-- Add keys for table clamsbase2.protected_spp_events

ALTER TABLE clamsbase2.protected_spp_events ADD CONSTRAINT prot_spp_events_pk PRIMARY KEY (ship,survey,event_id)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.protected_spp_events IS 'Contains event information regarding any protected species encountered during survey work.'
/

-- Table clamsbase2.protected_spp_event_data

CREATE TABLE clamsbase2.protected_spp_event_data(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  event_id Number(6,2) NOT NULL,
  event_parameter Varchar2(50 ) NOT NULL,
  parameter_value Varchar2(4000 ) NOT NULL
)
/

-- Add keys for table clamsbase2.protected_spp_event_data

ALTER TABLE clamsbase2.protected_spp_event_data ADD CONSTRAINT prot_spp_event_data_pk PRIMARY KEY (ship,survey,event_id,event_parameter)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.protected_spp_event_data IS 'Stores the event specific data for protected species events.'
/

-- Table clamsbase2.protected_spp_event_parameters

CREATE TABLE clamsbase2.protected_spp_event_parameters(
  event_parameter Varchar2(50 ) NOT NULL,
  gui_widget_name Varchar2(50 ) NOT NULL,
  PARAMETER_TYPE Varchar2(32 ) NOT NULL,
  PARAMETER_UNITS Varchar2(32 ) NOT NULL,
  description Varchar2(250 ) NOT NULL,
  DEVICE_ID Number(4,0) DEFAULT 0 NOT NULL
)
/

-- Add keys for table clamsbase2.protected_spp_event_parameters

ALTER TABLE clamsbase2.protected_spp_event_parameters ADD CONSTRAINT prot_spp_event_parm_pk PRIMARY KEY (event_parameter)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.protected_spp_event_parameters IS 'Lookup table containing observation types for protected species events.'
/

-- Table clamsbase2.CATCH_SUMMARY

CREATE TABLE clamsbase2.CATCH_SUMMARY(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  EVENT_ID Number(6,2) NOT NULL,
  SAMPLE_ID Number(6,0) NOT NULL,
  PARENT_SAMPLE Number(6,0) NOT NULL,
  PARTITION Varchar2(50 ) NOT NULL,
  SPECIES_CODE Number(7,0) NOT NULL,
  SUBCATEGORY Varchar2(128 ),
  SCIENTIFIC_NAME Varchar2(128 ) NOT NULL,
  COMMON_NAME Varchar2(128 ) NOT NULL,
  WEIGHT_IN_HAUL Number NOT NULL,
  SAMPLED_WEIGHT Number NOT NULL,
  NUMBER_IN_HAUL Number NOT NULL,
  SAMPLED_NUMBER Number NOT NULL,
  FREQUENCY_EXPANSION Number NOT NULL,
  IN_MIX Number NOT NULL,
  WHOLE_HAULED Number NOT NULL
)
/

-- Create indexes for table clamsbase2.CATCH_SUMMARY

CREATE INDEX IX_catch_summary_spp_fk ON clamsbase2.CATCH_SUMMARY (SPECIES_CODE)
/

-- Add keys for table clamsbase2.CATCH_SUMMARY

ALTER TABLE clamsbase2.CATCH_SUMMARY ADD CONSTRAINT PK_CATCH_SUMMARY PRIMARY KEY (ship,survey,EVENT_ID,SAMPLE_ID)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.CATCH_SUMMARY IS 'Contains the computed catch summary for an event. The data contained in this table is externally computed. It is up to the user to ensure that the results reflect the state of the underlying data at the time of querying.'
/

-- Table clamsbase2.LENGTH_HISTOGRAM

CREATE TABLE clamsbase2.LENGTH_HISTOGRAM(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  EVENT_ID Number(6,2) NOT NULL,
  SAMPLE_ID Number(6,0) NOT NULL,
  PARTITION Varchar2(50 ) NOT NULL,
  SPECIES_CODE Number(7,0) NOT NULL,
  SUBCATEGORY Varchar2(128 ) NOT NULL,
  LENGTH Number NOT NULL,
  LENGTH_TYPE Varchar2(128 ) NOT NULL,
  FREQUENCY_TOTAL Number NOT NULL,
  FREQUENCY_MALES Number NOT NULL,
  FREQUENCY_FEMALES Number NOT NULL,
  FREQUENCY_UNSEXED Number NOT NULL
)
/

-- Create indexes for table clamsbase2.LENGTH_HISTOGRAM

CREATE INDEX IX_len_hist_spp_fk ON clamsbase2.LENGTH_HISTOGRAM (SPECIES_CODE)
/

-- Add keys for table clamsbase2.LENGTH_HISTOGRAM

ALTER TABLE clamsbase2.LENGTH_HISTOGRAM ADD CONSTRAINT PK_LENGTH_HISTOGRAM PRIMARY KEY (ship,survey,EVENT_ID,SAMPLE_ID,PARTITION,SPECIES_CODE,SUBCATEGORY,LENGTH,LENGTH_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.LENGTH_HISTOGRAM IS 'Contains the computed length histogram data for an event. The data contained in this table is externally computed. It is up to the user to ensure that the results reflect the state of the underlying data at the time of querying.'
/

-- Table clamsbase2.protected_spp_species

CREATE TABLE clamsbase2.protected_spp_species(
  common_name Varchar2(128 ) NOT NULL,
  scientific_name Varchar2(128 ),
  display_order Number(3,0),
  active Number(1,0) DEFAULT 1 NOT NULL
)
/

-- Add keys for table clamsbase2.protected_spp_species

ALTER TABLE clamsbase2.protected_spp_species ADD CONSTRAINT protected_spp_species_pk PRIMARY KEY (common_name)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.protected_spp_species IS 'protected_spp_species contains the list of protected species available to select in the protected species reporting application. '
/

-- Table clamsbase2.underway_data

CREATE TABLE clamsbase2.underway_data(
  ship Number(4,0) NOT NULL,
  survey Number(8,0) NOT NULL,
  time_stamp Timestamp(3) NOT NULL,
  MEASUREMENT_TYPE Varchar2(50 ) NOT NULL,
  latitude Number(10,7) NOT NULL,
  longitude Number(10,7) NOT NULL,
  measurement_value Number NOT NULL
)
/

-- Add keys for table clamsbase2.underway_data

ALTER TABLE clamsbase2.underway_data ADD CONSTRAINT PK_underway_data PRIMARY KEY (ship,survey,time_stamp,MEASUREMENT_TYPE)
/

-- Table and Columns comments section

COMMENT ON TABLE clamsbase2.underway_data IS 'underway_data stores environmental data that is collected while the vessel is underway during a survey.'
/


-- Create foreign keys (relationships) section ------------------------------------------------- 

ALTER TABLE clamsbase2.BASKETS ADD CONSTRAINT BASKET_BASKTYPES_FK FOREIGN KEY (BASKET_TYPE) REFERENCES clamsbase2.BASKET_TYPES (BASKET_TYPE)
/



ALTER TABLE clamsbase2.BASKETS ADD CONSTRAINT BASKET_INPUTDEVICE_FK FOREIGN KEY (DEVICE_ID) REFERENCES clamsbase2.DEVICES (DEVICE_ID)
/



ALTER TABLE clamsbase2.BASKETS ADD CONSTRAINT BASKET_SAMPLE_FK FOREIGN KEY (ship, survey, EVENT_ID, SAMPLE_ID) REFERENCES clamsbase2.SAMPLES (ship, survey, EVENT_ID, SAMPLE_ID)
/



ALTER TABLE clamsbase2.CONDITIONALS ADD CONSTRAINT CONDITIONALS_CONDEFS_FK FOREIGN KEY (CONDITIONAL) REFERENCES clamsbase2.CONDITIONAL_DEFINITIONS (CONDITIONAL)
/



ALTER TABLE clamsbase2.CONDITIONALS ADD CONSTRAINT CONDITIONALS_PROTONAME_FK FOREIGN KEY (PROTOCOL_NAME) REFERENCES clamsbase2.SPECIMEN_PROTOCOL (PROTOCOL_NAME)
/



ALTER TABLE clamsbase2.DEVICE_CONFIGURATION ADD CONSTRAINT DEVCONFIG_DEVICE_FK FOREIGN KEY (DEVICE_ID) REFERENCES clamsbase2.DEVICES (DEVICE_ID)
/



ALTER TABLE clamsbase2.DEVICE_CONFIGURATION ADD CONSTRAINT DEVCONFIG_DEVPARMS_FK FOREIGN KEY (DEVICE_PARAMETER) REFERENCES clamsbase2.DEVICE_PARAMETERS (DEVICE_PARAMETER)
/



ALTER TABLE clamsbase2.GEAR_PARTITIONS ADD CONSTRAINT GEARPARTS_PARTYPES_FK FOREIGN KEY (PARTITION_TYPE) REFERENCES clamsbase2.GEAR_PARTITION_TYPES (PARTITION_TYPE)
/



ALTER TABLE clamsbase2.GEAR_ACCESSORY ADD CONSTRAINT GEAR_ACC_GEARACCTYPES_FK FOREIGN KEY (GEAR_ACCESSORY, GEAR_ACCESSORY_OPTION) REFERENCES clamsbase2.GEAR_ACCESSORY_OPTIONS (GEAR_ACCESSORY, GEAR_ACCESSORY_OPTION)
/



ALTER TABLE clamsbase2.GEAR_ACCESSORY ADD CONSTRAINT GEAR_ACC_EVENTS_FK FOREIGN KEY (ship, survey, EVENT_ID) REFERENCES clamsbase2.EVENTS (ship, survey, EVENT_ID)
/



ALTER TABLE clamsbase2.GEAR_ACCESSORY_OPTIONS ADD CONSTRAINT GEAR_ACC_OPTIONS_GEARACCTYP_FK FOREIGN KEY (GEAR_ACCESSORY) REFERENCES clamsbase2.GEAR_ACCESSORY_TYPES (GEAR_ACCESSORY)
/



ALTER TABLE clamsbase2.GEAR ADD CONSTRAINT GEAR_GEARTYPES_FK FOREIGN KEY (GEAR_TYPE) REFERENCES clamsbase2.GEAR_TYPES (GEAR_TYPE)
/



ALTER TABLE clamsbase2.GEAR_OPTIONS ADD CONSTRAINT GEAR_OPTS_GEARACCTYPS_FK FOREIGN KEY (GEAR_ACCESSORY) REFERENCES clamsbase2.GEAR_ACCESSORY_TYPES (GEAR_ACCESSORY)
/



ALTER TABLE clamsbase2.GEAR_OPTIONS ADD CONSTRAINT GEAR_OPT_BASKTYPES_FK FOREIGN KEY (BASKET_TYPE) REFERENCES clamsbase2.BASKET_TYPES (BASKET_TYPE)
/



ALTER TABLE clamsbase2.GEAR_OPTIONS ADD CONSTRAINT GEAR_OPT_GEARPARTS_FK FOREIGN KEY (PARTITION) REFERENCES clamsbase2.GEAR_PARTITIONS (PARTITION)
/



ALTER TABLE clamsbase2.GEAR_OPTIONS ADD CONSTRAINT GEAR_OPT_GEAR_FK FOREIGN KEY (GEAR) REFERENCES clamsbase2.GEAR (GEAR)
/



ALTER TABLE clamsbase2.GEAR_OPTIONS ADD CONSTRAINT GEAR_OPT_HAULPARMS_FK FOREIGN KEY (EVENT_PARAMETER) REFERENCES clamsbase2.EVENT_PARAMETERS (EVENT_PARAMETER)
/



ALTER TABLE clamsbase2.GEAR_OPTIONS ADD CONSTRAINT GEAR_OPT_HAULPERF_FK FOREIGN KEY (PERFORMANCE_CODE) REFERENCES clamsbase2.EVENT_PERFORMANCE (PERFORMANCE_CODE)
/



ALTER TABLE clamsbase2.GEAR_OPTIONS ADD CONSTRAINT GEAR_OPT_HAULTYPES_FK FOREIGN KEY (EVENT_TYPE) REFERENCES clamsbase2.EVENT_TYPES (EVENT_TYPE)
/



ALTER TABLE clamsbase2.EVENT_STREAM_DATA ADD CONSTRAINT DEVICES_EV_STREAM_DATA_FK FOREIGN KEY (DEVICE_ID) REFERENCES clamsbase2.DEVICES (DEVICE_ID)
/



ALTER TABLE clamsbase2.EVENT_STREAM_DATA ADD CONSTRAINT EVENTS_EV_STREAM_DATA_FK FOREIGN KEY (ship, survey, EVENT_ID) REFERENCES clamsbase2.EVENTS (ship, survey, EVENT_ID)
/



ALTER TABLE clamsbase2.EVENT_STREAM_DATA ADD CONSTRAINT MTYPES_EV_STREAM_DATA_FK FOREIGN KEY (MEASUREMENT_TYPE) REFERENCES clamsbase2.MEASUREMENT_TYPES (MEASUREMENT_TYPE)
/



ALTER TABLE clamsbase2.EVENT_DATA ADD CONSTRAINT GEAR_PARTS_EVENT_DATA_FK FOREIGN KEY (PARTITION) REFERENCES clamsbase2.GEAR_PARTITIONS (PARTITION)
/



ALTER TABLE clamsbase2.EVENT_DATA ADD CONSTRAINT EVENT_PARMS_EVENT_DATA_FK FOREIGN KEY (EVENT_PARAMETER) REFERENCES clamsbase2.EVENT_PARAMETERS (EVENT_PARAMETER)
/



ALTER TABLE clamsbase2.EVENT_DATA ADD CONSTRAINT EVENTS_EVENT_DATA_FK FOREIGN KEY (ship, survey, EVENT_ID) REFERENCES clamsbase2.EVENTS (ship, survey, EVENT_ID)
/



ALTER TABLE clamsbase2.EVENTS ADD CONSTRAINT GEAR_EVENTS_FK FOREIGN KEY (GEAR) REFERENCES clamsbase2.GEAR (GEAR)
/



ALTER TABLE clamsbase2.EVENTS ADD CONSTRAINT EVENT_PERF_EVENTS_FK FOREIGN KEY (PERFORMANCE_CODE) REFERENCES clamsbase2.EVENT_PERFORMANCE (PERFORMANCE_CODE)
/



ALTER TABLE clamsbase2.EVENTS ADD CONSTRAINT EVENT_TYPES_EVENT_FK FOREIGN KEY (EVENT_TYPE) REFERENCES clamsbase2.EVENT_TYPES (EVENT_TYPE)
/



ALTER TABLE clamsbase2.EVENTS ADD CONSTRAINT PERSONNEL_EVENTS_FK FOREIGN KEY (SCIENTIST) REFERENCES clamsbase2.PERSONNEL (SCIENTIST)
/



ALTER TABLE clamsbase2.MATURITY_DESCRIPTION ADD CONSTRAINT MATURITY_DESC_MATURITYTABLE_FK FOREIGN KEY (MATURITY_TABLE) REFERENCES clamsbase2.MATURITY_TABLES (MATURITY_TABLE)
/



ALTER TABLE clamsbase2.MEASUREMENTS ADD CONSTRAINT MEASUREMENT_INPUTDEVICE_FK FOREIGN KEY (DEVICE_ID) REFERENCES clamsbase2.DEVICES (DEVICE_ID)
/



ALTER TABLE clamsbase2.MEASUREMENTS ADD CONSTRAINT MEASUREMENT_MTYPES_FK FOREIGN KEY (MEASUREMENT_TYPE) REFERENCES clamsbase2.MEASUREMENT_TYPES (MEASUREMENT_TYPE)
/



ALTER TABLE clamsbase2.MEASUREMENTS ADD CONSTRAINT MEASUREMENT_SPECIMEN_FK FOREIGN KEY (ship, survey, EVENT_ID, SAMPLE_ID, SPECIMEN_ID) REFERENCES clamsbase2.SPECIMEN (ship, survey, EVENT_ID, SAMPLE_ID, SPECIMEN_ID)
/



ALTER TABLE clamsbase2.MEASUREMENT_SETUP ADD CONSTRAINT DEV_INTERFACE_M_SETUP_FK FOREIGN KEY (DEVICE_INTERFACE) REFERENCES clamsbase2.DEVICE_INTERFACES (DEVICE_INTERFACE)
/



ALTER TABLE clamsbase2.MEASUREMENT_SETUP ADD CONSTRAINT M_SETUP_INPUTDEVICE_FK FOREIGN KEY (DEVICE_ID) REFERENCES clamsbase2.DEVICES (DEVICE_ID)
/



ALTER TABLE clamsbase2.MEASUREMENT_SETUP ADD CONSTRAINT M_SETUP_MTYPES_FK FOREIGN KEY (MEASUREMENT_TYPE) REFERENCES clamsbase2.MEASUREMENT_TYPES (MEASUREMENT_TYPE)
/



ALTER TABLE clamsbase2.MEASUREMENT_SETUP ADD CONSTRAINT M_SETUP_WORKSTATION_FK FOREIGN KEY (WORKSTATION_ID) REFERENCES clamsbase2.WORKSTATIONS (WORKSTATION_ID)
/



ALTER TABLE clamsbase2.OVERRIDES ADD CONSTRAINT OVERRIDE_PERSONNEL_FK FOREIGN KEY (SCIENTIST) REFERENCES clamsbase2.PERSONNEL (SCIENTIST)
/



ALTER TABLE clamsbase2.PROTOCOL_DEFINITIONS ADD CONSTRAINT PROTODEF_PROTONAME_FK FOREIGN KEY (PROTOCOL_NAME) REFERENCES clamsbase2.SPECIMEN_PROTOCOL (PROTOCOL_NAME)
/



ALTER TABLE clamsbase2.SAMPLE_DATA ADD CONSTRAINT SAMPLE_DATA_SAMPLEPARMS_FK FOREIGN KEY (SAMPLE_PARAMETER) REFERENCES clamsbase2.SAMPLE_PARAMETERS (SAMPLE_PARAMETER)
/



ALTER TABLE clamsbase2.SAMPLES ADD CONSTRAINT SAMPLE_GEARPARTS_FK FOREIGN KEY (PARTITION) REFERENCES clamsbase2.GEAR_PARTITIONS (PARTITION)
/



ALTER TABLE clamsbase2.SAMPLES ADD CONSTRAINT SAMPLE_PERSONNEL_FK FOREIGN KEY (SCIENTIST) REFERENCES clamsbase2.PERSONNEL (SCIENTIST)
/



ALTER TABLE clamsbase2.SAMPLES ADD CONSTRAINT SAMPLE_SAMPLETYPES_FK FOREIGN KEY (SAMPLE_TYPE) REFERENCES clamsbase2.SAMPLE_TYPES (SAMPLE_TYPE)
/



ALTER TABLE clamsbase2.SAMPLES ADD CONSTRAINT SAMPLE_SPECIES_FK FOREIGN KEY (SPECIES_CODE) REFERENCES clamsbase2.SPECIES (SPECIES_CODE)
/



ALTER TABLE clamsbase2.SPECIMEN ADD CONSTRAINT SPECIMEN_PERSONNEL_FK FOREIGN KEY (SCIENTIST) REFERENCES clamsbase2.PERSONNEL (SCIENTIST)
/



ALTER TABLE clamsbase2.SPECIMEN ADD CONSTRAINT SPECIMEN_PROTONAME_FK FOREIGN KEY (PROTOCOL_NAME) REFERENCES clamsbase2.SPECIMEN_PROTOCOL (PROTOCOL_NAME)
/



ALTER TABLE clamsbase2.SPECIMEN ADD CONSTRAINT SPECIMEN_SAMPLE_FK FOREIGN KEY (ship, survey, EVENT_ID, SAMPLE_ID) REFERENCES clamsbase2.SAMPLES (ship, survey, EVENT_ID, SAMPLE_ID)
/



ALTER TABLE clamsbase2.SPECIMEN ADD CONSTRAINT SPECIMEN_SAMPMETH_FK FOREIGN KEY (SAMPLING_METHOD) REFERENCES clamsbase2.SAMPLING_METHODS (SAMPLING_METHOD)
/



ALTER TABLE clamsbase2.SPECIMEN ADD CONSTRAINT SPECIMEN_WORKSTATION_FK FOREIGN KEY (WORKSTATION_ID) REFERENCES clamsbase2.WORKSTATIONS (WORKSTATION_ID)
/



ALTER TABLE clamsbase2.VALIDATIONS ADD CONSTRAINT VALIDATIONS_MTYPES_FK FOREIGN KEY (MEASUREMENT_TYPE) REFERENCES clamsbase2.MEASUREMENT_TYPES (MEASUREMENT_TYPE)
/



ALTER TABLE clamsbase2.VALIDATIONS ADD CONSTRAINT VALIDATIONS_PROTONAME_FK FOREIGN KEY (PROTOCOL_NAME) REFERENCES clamsbase2.SPECIMEN_PROTOCOL (PROTOCOL_NAME)
/



ALTER TABLE clamsbase2.VALIDATIONS ADD CONSTRAINT VALIDATIONS_VALDEFS_FK FOREIGN KEY (VALIDATION) REFERENCES clamsbase2.VALIDATION_DEFINITIONS (VALIDATION)
/



ALTER TABLE clamsbase2.WORKSTATION_CONFIGURATION ADD CONSTRAINT WRK_CONFIG_WRK_FK FOREIGN KEY (WORKSTATION_ID) REFERENCES clamsbase2.WORKSTATIONS (WORKSTATION_ID)
/



ALTER TABLE clamsbase2.SAMPLES ADD CONSTRAINT EVENTS_SAMPLES_FK FOREIGN KEY (ship, survey, EVENT_ID) REFERENCES clamsbase2.EVENTS (ship, survey, EVENT_ID)
/



ALTER TABLE clamsbase2.SPECIES_PARAMETERS ADD CONSTRAINT SP_PARM_SPP_TYPES_FK FOREIGN KEY (PARAMETER_TYPE) REFERENCES clamsbase2.PARAMETER_TYPES (PARAMETER_TYPE)
/



ALTER TABLE clamsbase2.SAMPLES ADD CONSTRAINT SAMPLE_SAMPLE_RK FOREIGN KEY (ship, survey, EVENT_ID, PARENT_SAMPLE) REFERENCES clamsbase2.SAMPLES (ship, survey, EVENT_ID, SAMPLE_ID)
/



ALTER TABLE clamsbase2.SPECIES_ASSOCIATIONS ADD CONSTRAINT SP_SUBCAT_SP_ASSOC_FK FOREIGN KEY (SUBCATEGORY) REFERENCES clamsbase2.SPECIES_SUBCATEGORIES (SUBCATEGORY)
/



ALTER TABLE clamsbase2.survey_data ADD CONSTRAINT survey_parm_types_fk FOREIGN KEY (survey_parameter) REFERENCES clamsbase2.survey_parameters (survey_parameter)
/



ALTER TABLE clamsbase2.survey_data ADD CONSTRAINT survey_survey_parms_fk FOREIGN KEY (survey, ship) REFERENCES clamsbase2.surveys (survey, ship)
/



ALTER TABLE clamsbase2.surveys ADD CONSTRAINT personnel_surveys_fk FOREIGN KEY (chief_scientist) REFERENCES clamsbase2.PERSONNEL (SCIENTIST)
/



ALTER TABLE clamsbase2.survey_parameters ADD CONSTRAINT param_types_survey_ptypes_fk FOREIGN KEY (parameter_type) REFERENCES clamsbase2.PARAMETER_TYPES (PARAMETER_TYPE)
/



ALTER TABLE clamsbase2.EVENTS ADD CONSTRAINT surveys_haul_fk FOREIGN KEY (survey, ship) REFERENCES clamsbase2.surveys (survey, ship)
/



ALTER TABLE clamsbase2.EVENTS ADD CONSTRAINT ships_haul_fk FOREIGN KEY (ship) REFERENCES clamsbase2.SHIPS (ship)
/



ALTER TABLE clamsbase2.EVENT_PARAMETERS ADD CONSTRAINT param_types_event_params_fk FOREIGN KEY (parameter_type) REFERENCES clamsbase2.PARAMETER_TYPES (PARAMETER_TYPE)
/



ALTER TABLE clamsbase2.SAMPLE_DATA ADD CONSTRAINT samples_sample_data_fk FOREIGN KEY (ship, survey, EVENT_ID, SAMPLE_ID) REFERENCES clamsbase2.SAMPLES (ship, survey, EVENT_ID, SAMPLE_ID)
/



ALTER TABLE clamsbase2.SAMPLE_PARAMETERS ADD CONSTRAINT param_types_sample_params_fk FOREIGN KEY (PARAMETER_TYPE) REFERENCES clamsbase2.PARAMETER_TYPES (PARAMETER_TYPE)
/



ALTER TABLE clamsbase2.MEASUREMENT_TYPES ADD CONSTRAINT param_types_measure_types_fk FOREIGN KEY (PARAMETER_TYPE) REFERENCES clamsbase2.PARAMETER_TYPES (PARAMETER_TYPE)
/



ALTER TABLE clamsbase2.SPECIES_PARAMETERS ADD CONSTRAINT param_units_sp_params_fk FOREIGN KEY (PARAMETER_UNIT) REFERENCES clamsbase2.PARAMETER_UNITS (PARAMETER_UNITS)
/



ALTER TABLE clamsbase2.SAMPLE_PARAMETERS ADD CONSTRAINT param_units_samp_params_fk FOREIGN KEY (PARAMETER_UNIT) REFERENCES clamsbase2.PARAMETER_UNITS (PARAMETER_UNITS)
/



ALTER TABLE clamsbase2.survey_parameters ADD CONSTRAINT param_units_survey_ptypes_fk FOREIGN KEY (PARAMETER_UNIT) REFERENCES clamsbase2.PARAMETER_UNITS (PARAMETER_UNITS)
/



ALTER TABLE clamsbase2.EVENT_PARAMETERS ADD CONSTRAINT param_units_event_params_fk FOREIGN KEY (PARAMETER_UNIT) REFERENCES clamsbase2.PARAMETER_UNITS (PARAMETER_UNITS)
/



ALTER TABLE clamsbase2.MEASUREMENT_TYPES ADD CONSTRAINT param_units_measure_types_fk FOREIGN KEY (PARAMETER_UNIT) REFERENCES clamsbase2.PARAMETER_UNITS (PARAMETER_UNITS)
/



ALTER TABLE clamsbase2.SPECIES_ASSOCIATIONS ADD CONSTRAINT SPECIES_SP_ASSOC_FK FOREIGN KEY (SPECIES_CODE) REFERENCES clamsbase2.SPECIES (SPECIES_CODE)
/



ALTER TABLE clamsbase2.SPECIES_DATA ADD CONSTRAINT SPECIES_SP_DATA_FK FOREIGN KEY (SPECIES_CODE) REFERENCES clamsbase2.SPECIES (SPECIES_CODE)
/



ALTER TABLE clamsbase2.SPECIES_DATA ADD CONSTRAINT SP_PARAMS_SP_DATA_FK FOREIGN KEY (SPECIES_PARAMETER) REFERENCES clamsbase2.SPECIES_PARAMETERS (SPECIES_PARAMETER)
/



ALTER TABLE clamsbase2.SPECIES_DATA ADD CONSTRAINT SP_SUBCAT_SP_DATA_FK FOREIGN KEY (SUBCATEGORY) REFERENCES clamsbase2.SPECIES_SUBCATEGORIES (SUBCATEGORY)
/



ALTER TABLE clamsbase2.SAMPLES ADD CONSTRAINT SP_SUBCAT_SAMPLES_FK FOREIGN KEY (SUBCATEGORY) REFERENCES clamsbase2.SPECIES_SUBCATEGORIES (SUBCATEGORY)
/



ALTER TABLE clamsbase2.PROTOCOL_MAP ADD CONSTRAINT SPECIMEN_PROTO_PROTO_MAP_FK FOREIGN KEY (PROTOCOL_NAME) REFERENCES clamsbase2.SPECIMEN_PROTOCOL (PROTOCOL_NAME)
/



ALTER TABLE clamsbase2.PROTOCOL_MAP ADD CONSTRAINT SPECIES_PROTO_MAP_FK FOREIGN KEY (SPECIES_CODE) REFERENCES clamsbase2.SPECIES (SPECIES_CODE)
/



ALTER TABLE clamsbase2.PROTOCOL_MAP ADD CONSTRAINT SP_SUBCAT_PROTO_MAP_FK FOREIGN KEY (SUBCATEGORY) REFERENCES clamsbase2.SPECIES_SUBCATEGORIES (SUBCATEGORY)
/



ALTER TABLE clamsbase2.SPECIES ADD CONSTRAINT species_species_fk FOREIGN KEY (PARENT_TAXON) REFERENCES clamsbase2.SPECIES (SPECIES_CODE)
/



ALTER TABLE clamsbase2.surveys ADD CONSTRAINT ships_surveys_fk FOREIGN KEY (ship) REFERENCES clamsbase2.SHIPS (ship)
/



ALTER TABLE clamsbase2.VALIDATION_CONFIGURATION ADD CONSTRAINT V_DEFINITIONS_V_CONFIG_FK FOREIGN KEY (VALIDATION) REFERENCES clamsbase2.VALIDATION_DEFINITIONS (VALIDATION)
/



ALTER TABLE clamsbase2.GEAR_ACCESSORY_TYPES ADD CONSTRAINT PARAM_TYPE_GA_TYPES_FK FOREIGN KEY (PARAMETER_TYPE) REFERENCES clamsbase2.PARAMETER_TYPES (PARAMETER_TYPE)
/



ALTER TABLE clamsbase2.GEAR_ACCESSORY_TYPES ADD CONSTRAINT PARAM_UNITS_GA_TYPES_FK FOREIGN KEY (PARAMETER_UNIT) REFERENCES clamsbase2.PARAMETER_UNITS (PARAMETER_UNITS)
/



ALTER TABLE clamsbase2.surveys ADD CONSTRAINT survey_regions_surveys_fk FOREIGN KEY (region) REFERENCES clamsbase2.survey_regions (region)
/



ALTER TABLE clamsbase2.surveys ADD CONSTRAINT sea_areas_surveys_fk FOREIGN KEY (sea_area) REFERENCES clamsbase2.survey_sea_areas (IHO_sea_area)
/



ALTER TABLE clamsbase2.SPECIMEN ADD CONSTRAINT mat_table_specimen_fk FOREIGN KEY (MATURITY_TABLE) REFERENCES clamsbase2.MATURITY_TABLES (MATURITY_TABLE)
/



ALTER TABLE clamsbase2.surveys ADD CONSTRAINT ports_survey_end_fk FOREIGN KEY (start_port) REFERENCES clamsbase2.survey_ports (port)
/



ALTER TABLE clamsbase2.surveys ADD CONSTRAINT ports_survey_start_fk FOREIGN KEY (end_port) REFERENCES clamsbase2.survey_ports (port)
/



ALTER TABLE clamsbase2.QUALITY_CONTROL ADD CONSTRAINT EVENT_QC_CONT_FK FOREIGN KEY (ship, survey, EVENT_ID) REFERENCES clamsbase2.EVENTS (ship, survey, EVENT_ID)
/



ALTER TABLE clamsbase2.QUALITY_CONTROL ADD CONSTRAINT QC_TYPE_QC_CONT_FK FOREIGN KEY (QC_TYPE) REFERENCES clamsbase2.QC_TYPES (QC_TYPE)
/



ALTER TABLE clamsbase2.protected_spp_events ADD CONSTRAINT surveys_p_spp_events_fk FOREIGN KEY (survey, ship) REFERENCES clamsbase2.surveys (survey, ship)
/



ALTER TABLE clamsbase2.protected_spp_events ADD CONSTRAINT personnel_p_spp_events_fk FOREIGN KEY (SCIENTIST) REFERENCES clamsbase2.PERSONNEL (SCIENTIST)
/



ALTER TABLE clamsbase2.protected_spp_event_data ADD CONSTRAINT p_spp_ev_p_spp_ev_data_fk FOREIGN KEY (ship, survey, event_id) REFERENCES clamsbase2.protected_spp_events (ship, survey, event_id)
/



ALTER TABLE clamsbase2.protected_spp_event_parameters ADD CONSTRAINT param_types_p_spp_ev_parms_fk FOREIGN KEY (PARAMETER_TYPE) REFERENCES clamsbase2.PARAMETER_TYPES (PARAMETER_TYPE)
/



ALTER TABLE clamsbase2.protected_spp_event_parameters ADD CONSTRAINT param_units_p_spp_ev_parms_fk FOREIGN KEY (PARAMETER_UNITS) REFERENCES clamsbase2.PARAMETER_UNITS (PARAMETER_UNITS)
/



ALTER TABLE clamsbase2.protected_spp_event_data ADD CONSTRAINT p_spp_evp_p_spp_ev_data_fk FOREIGN KEY (event_parameter) REFERENCES clamsbase2.protected_spp_event_parameters (event_parameter)
/



ALTER TABLE clamsbase2.OVERRIDES ADD CONSTRAINT overrides_events_fk FOREIGN KEY (ship, survey, EVENT_ID) REFERENCES clamsbase2.EVENTS (ship, survey, EVENT_ID)
/



ALTER TABLE clamsbase2.CATCH_SUMMARY ADD CONSTRAINT catch_sum_samples_fk FOREIGN KEY (ship, survey, EVENT_ID, SAMPLE_ID) REFERENCES clamsbase2.SAMPLES (ship, survey, EVENT_ID, SAMPLE_ID)
/



ALTER TABLE clamsbase2.CATCH_SUMMARY ADD CONSTRAINT catch_summary_samples_fk FOREIGN KEY (ship, survey, EVENT_ID, PARENT_SAMPLE) REFERENCES clamsbase2.SAMPLES (ship, survey, EVENT_ID, SAMPLE_ID)
/



ALTER TABLE clamsbase2.CATCH_SUMMARY ADD CONSTRAINT catch_summary_spp_fk FOREIGN KEY (SPECIES_CODE) REFERENCES clamsbase2.SPECIES (SPECIES_CODE)
/



ALTER TABLE clamsbase2.CATCH_SUMMARY ADD CONSTRAINT catch_summary_spp_subcat_fk FOREIGN KEY (SUBCATEGORY) REFERENCES clamsbase2.SPECIES_SUBCATEGORIES (SUBCATEGORY)
/



ALTER TABLE clamsbase2.CATCH_SUMMARY ADD CONSTRAINT catch_summary_gear_parts_fk FOREIGN KEY (PARTITION) REFERENCES clamsbase2.GEAR_PARTITIONS (PARTITION)
/



ALTER TABLE clamsbase2.LENGTH_HISTOGRAM ADD CONSTRAINT len_hist_samples_fk FOREIGN KEY (ship, survey, EVENT_ID, SAMPLE_ID) REFERENCES clamsbase2.SAMPLES (ship, survey, EVENT_ID, SAMPLE_ID)
/



ALTER TABLE clamsbase2.LENGTH_HISTOGRAM ADD CONSTRAINT len_hist_spp_fk FOREIGN KEY (SPECIES_CODE) REFERENCES clamsbase2.SPECIES (SPECIES_CODE)
/



ALTER TABLE clamsbase2.LENGTH_HISTOGRAM ADD CONSTRAINT len_hist_gear_parts_fk FOREIGN KEY (PARTITION) REFERENCES clamsbase2.GEAR_PARTITIONS (PARTITION)
/



ALTER TABLE clamsbase2.protected_spp_event_parameters ADD CONSTRAINT prot_spp_ev_parm_devices_fk FOREIGN KEY (DEVICE_ID) REFERENCES clamsbase2.DEVICES (DEVICE_ID)
/



ALTER TABLE clamsbase2.LENGTH_HISTOGRAM ADD CONSTRAINT len_hist_subcat_fk FOREIGN KEY (SUBCATEGORY) REFERENCES clamsbase2.SPECIES_SUBCATEGORIES (SUBCATEGORY)
/



ALTER TABLE clamsbase2.underway_data ADD CONSTRAINT surveys_uw_data FOREIGN KEY (survey, ship) REFERENCES clamsbase2.surveys (survey, ship)
/



ALTER TABLE clamsbase2.underway_data ADD CONSTRAINT measure_types_uw_data_fk FOREIGN KEY (MEASUREMENT_TYPE) REFERENCES clamsbase2.MEASUREMENT_TYPES (MEASUREMENT_TYPE)
/



-- Grant permissions section -------------------------------------------------


GRANT SELECT ON clamsbase2.SPECIES TO macebase2
/
GRANT REFERENCES ON clamsbase2.SPECIES TO macebase2
/
GRANT SELECT ON clamsbase2.SPECIES_SUBCATEGORIES TO macebase2
/
GRANT REFERENCES ON clamsbase2.SPECIES_SUBCATEGORIES TO macebase2
/
GRANT SELECT ON clamsbase2.surveys TO macebase2
/
GRANT INSERT ON clamsbase2.surveys TO macebase2
/
GRANT UPDATE ON clamsbase2.surveys TO macebase2
/
GRANT DELETE ON clamsbase2.surveys TO macebase2
/
GRANT REFERENCES ON clamsbase2.surveys TO macebase2
/
GRANT SELECT ON clamsbase2.survey_data TO macebase2
/
GRANT INSERT ON clamsbase2.survey_data TO macebase2
/
GRANT UPDATE ON clamsbase2.survey_data TO macebase2
/
GRANT DELETE ON clamsbase2.survey_data TO macebase2
/
GRANT SELECT ON clamsbase2.SHIPS TO macebase2
/
GRANT INSERT ON clamsbase2.SHIPS TO macebase2
/
GRANT UPDATE ON clamsbase2.SHIPS TO macebase2
/
GRANT DELETE ON clamsbase2.SHIPS TO macebase2
/
GRANT REFERENCES ON clamsbase2.SHIPS TO macebase2
/
GRANT SELECT ON clamsbase2.PERSONNEL TO macebase2
/
GRANT INSERT ON clamsbase2.PERSONNEL TO macebase2
/
GRANT UPDATE ON clamsbase2.PERSONNEL TO macebase2
/
GRANT DELETE ON clamsbase2.PERSONNEL TO macebase2
/
GRANT REFERENCES ON clamsbase2.PERSONNEL TO macebase2
/
GRANT SELECT ON clamsbase2.GEAR_PARTITIONS TO macebase2
/
GRANT REFERENCES ON clamsbase2.GEAR_PARTITIONS TO macebase2
/
GRANT SELECT ON clamsbase2.protected_spp_event_data TO macebase2
/
GRANT INSERT ON clamsbase2.protected_spp_event_data TO macebase2
/
GRANT UPDATE ON clamsbase2.protected_spp_event_data TO macebase2
/
GRANT DELETE ON clamsbase2.protected_spp_event_data TO macebase2
/
GRANT SELECT ON clamsbase2.protected_spp_events TO macebase2
/
GRANT INSERT ON clamsbase2.protected_spp_events TO macebase2
/
GRANT UPDATE ON clamsbase2.protected_spp_events TO macebase2
/
GRANT DELETE ON clamsbase2.protected_spp_events TO macebase2
/
GRANT SELECT ON clamsbase2.protected_spp_event_parameters TO macebase2
/
GRANT INSERT ON clamsbase2.protected_spp_event_parameters TO macebase2
/
GRANT UPDATE ON clamsbase2.protected_spp_event_parameters TO macebase2
/
GRANT DELETE ON clamsbase2.protected_spp_event_parameters TO macebase2
/
GRANT REFERENCES ON clamsbase2.protected_spp_event_parameters TO macebase2
/
GRANT SELECT ON clamsbase2.LENGTH_HISTOGRAM TO macebase2
/
GRANT INSERT ON clamsbase2.LENGTH_HISTOGRAM TO macebase2
/
GRANT UPDATE ON clamsbase2.LENGTH_HISTOGRAM TO macebase2
/
GRANT DELETE ON clamsbase2.LENGTH_HISTOGRAM TO macebase2
/
GRANT SELECT ON clamsbase2.CATCH_SUMMARY TO macebase2
/
GRANT INSERT ON clamsbase2.CATCH_SUMMARY TO macebase2
/
GRANT UPDATE ON clamsbase2.CATCH_SUMMARY TO macebase2
/
GRANT DELETE ON clamsbase2.CATCH_SUMMARY TO macebase2
/
GRANT SELECT ON clamsbase2.protected_spp_species TO macebase2
/
GRANT REFERENCES ON clamsbase2.GEAR TO macebase2
/
GRANT SELECT ON clamsbase2.GEAR TO macebase2
/


