ALTER TABLE nlg_objs.component
    ADD COLUMN IF NOT EXISTS parent_value VARCHAR;
