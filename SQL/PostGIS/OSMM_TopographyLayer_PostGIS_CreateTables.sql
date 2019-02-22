DROP SCHEMA IF EXISTS osmm_topo CASCADE;
COMMIT;

CREATE SCHEMA osmm_topo;
COMMIT;

CREATE TABLE osmm_topo.boundaryline
(
  fid character varying NOT NULL,
  featurecode integer,
  version integer,
  versiondate character varying,
  theme character varying[],
  accuracyofposition character varying,
  changedate character varying[],
  reasonforchange character varying[],
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  make character varying,
  physicallevel integer,
  physicalpresence character varying,
  geom geometry(MultiLineString,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE osmm_topo.cartographicsymbol
( 
  fid character varying NOT NULL,
  featurecode integer,
  version integer,
  versiondate character varying,
  theme character varying[],
  changedate character varying[],
  reasonforchange character varying[],
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  orientation integer,
  physicallevel integer,
  physicalpresence character varying,
  referencetofeature character varying,
  geom geometry(Point,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE osmm_topo.cartographictext
(
  fid character varying NOT NULL,
  featurecode integer,
  version integer,
  versiondate character varying,
  theme character varying[],
  changedate character varying[],
  reasonforchange character varying[],
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  make character varying,
  physicallevel integer,
  physicalpresence character varying,
  anchorposition integer,
  font integer,
  height double precision,
  orientation integer,
  textstring character varying,
  geom geometry(Point,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE osmm_topo.topographicarea
(
  
  fid character varying NOT NULL,
  featurecode integer,
  version integer,
  versiondate character varying,
  theme character varying[],
  calculatedareavalue double precision,
  changedate character varying[],
  reasonforchange character varying[],
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  make character varying,
  physicallevel integer,
  physicalpresence character varying,
  geom geometry(Polygon,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE osmm_topo.topographicline
(
  fid character varying NOT NULL,
  featurecode integer,
  version integer,
  versiondate character varying,
  theme character varying[],
  accuracyofposition character varying,
  changedate character varying[],
  reasonforchange character varying[],
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  nonboundingline character varying,
  heightabovedatum double precision,
  accuracyofheightabove character varying,
  heightabovegroundlevel double precision,
  accuracyofheightaboveground character varying,
  make character varying,
  physicallevel integer,
  physicalpresence character varying,
  geom geometry(LineString,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE osmm_topo.topographicpoint
(
  fid character varying NOT NULL,
  featurecode integer,
  version integer,
  versiondate character varying,
  theme character varying[],
  accuracyofposition character varying,
  changedate character varying[],
  reasonforchange character varying[],
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  heightabovedatum double precision,
  accuracyofheightabovedatum character varying,
  make character varying,
  physicallevel integer,
  physicalpresence character varying,
  referencetofeature character varying,
  geom geometry(Point,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;