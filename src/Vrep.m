classdef Vrep < handle

  properties

    vrep = []; clientID = -1;
    objWheel = zeros(1, 4);

  end

  methods


    function self = Vrep()

      [self.vrep, self.clientID] = self.startCommunicationSimulator();
      self.getObjectsSimulation();
      self.playSimulator();

    end


    function [vrep, clientID] = startCommunicationSimulator(self)

      CHANNEL = 19997;

      vrep = remApi('remoteApi');
      vrep.simxFinish(-1);
      clientID = vrep.simxStart('127.0.0.1', CHANNEL, true, true, 5000, 5);

      if (~clientID) disp('Connected to remote API server'); end

    end


    function stopCommunicationSimulator(self)

      self.vrep.simxFinish(-1);
      self.vrep.delete();

    end


    function playSimulator(self)

      if (~self.clientID)
        self.vrep.simxStartSimulation(self.clientID, self.vrep.simx_opmode_oneshot);
      end

    end


    function stopSimulator(self)

      if (~self.clientID)
        self.vrep.simxStopSimulation(self.clientID, self.vrep.simx_opmode_oneshot);
        self.stopCommunicationSimulator();
      end

    end


    function getObjectsSimulation(self)

      [~, self.objCamera] = self.vrep.simxGetObjectHandle(self.clientID, 'camera', self.vrep.simx_opmode_oneshot_wait);

    end


    function position = getPositionObject(self, reference)

      [~, position] = self.vrep.simxGetObjectPosition(self.clientID, reference, -1, self.vrep.simx_opmode_oneshot_wait);

    end


    function setPositionJoint(self, reference, positionAngular)

      self.vrep.simxSetJointTargetPosition(self.clientID, reference, deg2rad(positionAngular), self.vrep.simx_opmode_oneshot);

    end


    function positionAngular = getPositionJoint(self, reference)

      [~, positionAngular] = self.vrep.simxGetJointPosition(self.clientID, reference, self.vrep.simx_opmode_streaming);
      positionAngular = rad2deg(positionAngular);

    end


  end

end
