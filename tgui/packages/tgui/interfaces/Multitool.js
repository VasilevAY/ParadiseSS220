import { useBackend } from '../backend';
import { Box, Button, LabeledList, Fragment, Section } from '../components';
import { Window } from '../layouts';
import { UI_CLOSE } from '../constants';

export const Multitool = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    multitoolMenuId,
    buffer,
    bufferName,
    configureName,
  } = data;

  const machineNameDisplayed = (
    multitoolMenuId === "default_no_machine"
      ? "No machine attached" 
      : configureName 
        ? configureName 
        : "Unknown machine"
  );
  const isAllowed = !(
    multitoolMenuId === "default_no_machine"
    || multitoolMenuId === "access_denied"
  );

  const decideTabConfigurationMenu = menuID => {
    switch (menuID) {
      case "default_no_machine":
        return <DefaultMtoolMenu />;
      case "no_options":
        return <DefaultMtoolMenu />;
      case "access_denied":
        return <AccessDeniedMtoolMenu />;
      default:
        return "WE SHOULDN'T BE HERE!";
    }
  };

  return (
    <Window resizable>
      <Window.Content scrollable display="flex">
        <Section title={machineNameDisplayed}>
          {decideTabConfigurationMenu(multitoolMenuId)}
        </Section>
        <Section
          title="Multitool buffer"
          buttons={
            <Fragment>
              <Button
                content={"Add machine"}
                color={"blue"}
                disabled={buffer || !isAllowed}
                onClick={() => act('buffer_add')}
              />
              <Button
                content={"Flush"}
                color={"red"}
                disabled={!buffer}
                onClick={() => act('buffer_flush')}
              />
            </Fragment>
          }>
          <Box color="silver" bold>
            {buffer ? (bufferName ? bufferName : "Unknown machine") : ""}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

const DefaultMtoolMenu = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <div />
  );
};

const AccessDeniedMtoolMenu = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Box color="red" bold>
      ACCESS DENIED
    </Box>
  );
};
